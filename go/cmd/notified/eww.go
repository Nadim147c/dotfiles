package main

import (
	"bufio"
	"bytes"
	_ "embed"
	"encoding/json"
	"fmt"
	"log/slog"
	"net"
	"os"
	"slices"
	"text/template"
	"time"
)

//go:embed card.tmpl
var Template string

type EwwOutput struct {
	Notifications []Notification
}

const (
	maxRetries     = 20
	retryDelay     = 2 * time.Second
	reconnectDelay = 500 * time.Millisecond
)

var funcs = template.FuncMap{
	"path": func(p string) bool {
		if _, err := os.Stat(p); err == nil {
			return true
		}
		return false
	},
}

func Subscribe() {
	tmpl, err := template.New("eww-markup").Funcs(funcs).Parse(Template)
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

			active := MergeDuplicateNotifications(msg.Active)
			out := EwwOutput{Notifications: active}
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

// MergeDuplicateNotifications merges notifications with the same AppName and Summary,
// appending the count to the AppName (e.g., "Spotify (2)").
// Returns a new slice with cloned and merged notifications.
func MergeDuplicateNotifications(notifs []*Notification) []Notification {
	type key struct {
		AppName string
		Summary string
	}

	grouped := make(map[key][]Notification)

	// Group notifications by AppName and Summary
	for _, n := range notifs {
		k := key{AppName: n.AppName, Summary: n.Summary}
		grouped[k] = append(grouped[k], *n)
	}

	var result []Notification
	for k, group := range grouped {
		count := len(group)

		// Clone the first notification as the base
		cloned := group[0]
		if count > 1 {
			cloned.AppName = fmt.Sprintf("%s (%d)", k.AppName, count)
		}

		result = append(result, cloned)
	}

	slices.SortFunc(result, func(a, b Notification) int {
		return int(b.Time.Sub(a.Time))
	})

	return result
}
