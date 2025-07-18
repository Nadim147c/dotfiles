package main

import (
	"bufio"
	"bytes"
	_ "embed"
	"encoding/json"
	"log/slog"
	"net"
	"os"
	"text/template"
	"time"
)

//go:embed card.tmpl
var Template string

type EwwOutput struct {
	Notifications []*Notification
}

const (
	maxRetries     = 20
	retryDelay     = 2 * time.Second
	reconnectDelay = 1 * time.Second
)

func Subscribe() {
	tmpl, err := template.New("eww-markup").Parse(Template)
	if err != nil {
		panic(err)
	}

	encoder := json.NewEncoder(os.Stdout)

	for {
		conn, err := connectWithRetry()
		if err != nil {
			slog.Error("Failed to connect after retries", "error", err)
			time.Sleep(reconnectDelay)
			continue
		}
		slog.Info("Connected to notified daemon")

		scanner := bufio.NewScanner(conn)
		connected := true

		for connected && scanner.Scan() {
			line := scanner.Bytes()

			var msg BroadCastMessage
			if err := json.Unmarshal(line, &msg); err != nil {
				slog.Error("Failed to parse json", "error", err)
				continue
			}

			out := EwwOutput{Notifications: msg.Active}
			buf := bytes.NewBuffer(nil)
			err = tmpl.Execute(buf, out)
			if err != nil {
				slog.Error("Failed to render eww markup", "input", out, "error", err)
				continue
			}

			encoder.Encode(map[string]string{"active": buf.String()})
		}

		// Handle disconnection
		if scanner.Err() != nil {
			slog.Error("Connection error", "error", scanner.Err())
		} else {
			slog.Info("Connection closed by remote")
		}
		conn.Close()
		time.Sleep(reconnectDelay)
	}
}

func connectWithRetry() (net.Conn, error) {
	var lastErr error
	for i := range maxRetries {
		conn, err := net.Dial("unix", ListenSocket)
		if err == nil {
			return conn, nil
		}
		lastErr = err
		if i < maxRetries-1 {
			time.Sleep(retryDelay)
		}
	}
	return nil, lastErr
}
