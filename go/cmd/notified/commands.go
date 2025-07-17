package main

import (
	"bufio"
	"fmt"
	"log/slog"
	"net"
	"os"
	"strconv"
	"strings"
)

func HandleCommand(args []string) error {
	cmd := args[0]
	switch cmd {
	case "action", "close", "close-all":
	default:
		return fmt.Errorf("invalid command: %v", cmd)
	}

	conn, err := net.Dial("unix", CommandSocket)
	if err != nil {
		return fmt.Errorf("failed to create socket connection: %v", err)
	}
	defer conn.Close()

	_, err = fmt.Fprintln(conn, strings.Join(args, " "))
	return err
}

func (n *Server) StartCommandListener() error {
	os.Remove(CommandSocket)

	listener, err := net.Listen("unix", CommandSocket)
	if err != nil {
		slog.Error("Failed to start command listener", "error", err)
		return err
	}

	n.mu.Lock()
	n.command = listener
	n.mu.Unlock()

	go n.acceptCommandConnections()
	return nil
}

func (n *Server) acceptCommandConnections() {
	for {
		conn, err := n.command.Accept()
		if err != nil {
			if _, ok := err.(net.Error); ok {
				slog.Warn("Temporary accept error", "error", err)
				continue
			}
			slog.Error("Command listener accept failed", "error", err)
			return
		}
		go n.handleCommandConnection(conn)
	}
}

func (n *Server) handleCommandConnection(conn net.Conn) {
	defer conn.Close()
	scanner := bufio.NewScanner(conn)

	for scanner.Scan() {
		cmdLine := strings.TrimSpace(scanner.Text())

		parts := strings.SplitN(cmdLine, " ", 3)
		if len(parts) == 0 {
			continue
		}

		command := parts[0]
		switch command {
		case "action":
			if len(parts) < 3 {
				slog.Error("Missing arguments for action command")
				continue
			}
			id, err := strconv.ParseUint(parts[1], 10, 32)
			if err != nil {
				slog.Error("Invalid notification ID", "id", parts[1], "error", err)
				continue
			}
			if err := n.SendAction(uint32(id), parts[2]); err != nil {
				slog.Error("Failed to send action", "id", id, "action", parts[2], "error", err)
				fmt.Fprintf(conn, "ERROR: %v\n", err)
			} else {
				fmt.Fprintln(conn, "OK")
			}
			n.BroadCast()
		case "close":
			if len(parts) < 2 {
				fmt.Fprintln(conn, "ERROR: Missing notification ID for close command")
				continue
			}
			id, err := strconv.ParseUint(parts[1], 10, 32)
			if err != nil {
				fmt.Fprintf(conn, "ERROR: Invalid notification ID: %v\n", err)
				continue
			}
			slog.Info("Close command received", "id", id)
			n.CloseNotification(uint32(id))
			n.BroadCast()
		case "close-all":
			n.active.Reset()
			n.history.Reset()
			go n.BroadCast()
			fmt.Fprintln(conn, "OK (all notifications cleared)")

		default:
			slog.Warn("Unknown command received", "command", command)
			fmt.Fprintln(conn, "ERROR: Unknown command")
		}
	}

	if err := scanner.Err(); err != nil {
		slog.Error("Command connection error", "error", err)
	}
}
