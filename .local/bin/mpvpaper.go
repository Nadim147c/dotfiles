#!/usr/bin/env scriptisto

package main

// scriptisto-begin
// script_src: main.go
// build_once_cmd: go mod tidy
// build_cmd: go build -o script
// replace_shebang_with: //
// files:
//  - path: go.mod
//    content: |
//      module mpvpaper
//
//      go 1.24
// scriptisto-end

import (
	"bufio"
	"encoding/json"
	"fmt"
	"net"
	"os"
	"os/exec"
	"strings"
)

const MpvSocketPath = "/tmp/mpvpaper.sock"

type Client struct {
	Workspace struct {
		ID int `json:"id"`
	} `json:"workspace"`
	Floating bool `json:"floating"`
}

func main() {
	// Attempt wallpaper restore
	wallpaperPath, err := getWallpaperPath()
	if err != nil {
		fmt.Fprintln(os.Stderr, "Failed to read wallpaper path:", err)
		os.Exit(1)
	}

	if err := startMPVPaper(wallpaperPath); err != nil {
		fmt.Fprintln(os.Stderr, "Failed to start mpvpaper:", err)
	}

	workspace := 5 // fallback
	socketPath := fmt.Sprintf("%s/hypr/%s/.socket2.sock", os.Getenv("XDG_RUNTIME_DIR"), os.Getenv("HYPRLAND_INSTANCE_SIGNATURE"))

	conn, err := net.Dial("unix", socketPath)
	if err != nil {
		fmt.Println("Failed to connect Hyprland socket:", err)
		os.Exit(1)
	}
	defer conn.Close()

	scanner := bufio.NewScanner(conn)
	for scanner.Scan() {
		line := scanner.Text()
		if after, ok := strings.CutPrefix(line, "workspacev2>>"); ok {
			id := strings.Split(after, ",")[0]
			fmt.Sscanf(id, "%d", &workspace)
		}

		noClients, err := getWorkspaceClients(workspace)
		if err != nil {
			fmt.Println("Error checking clients:", err)
			continue
		}

		if noClients {
			sendMPVCmd(false)
		} else {
			sendMPVCmd(true)
		}
	}
}

func getWallpaperPath() (string, error) {
	data, err := os.ReadFile(os.ExpandEnv("$HOME/.cache/wallpaper"))
	if err != nil {
		return "", err
	}
	return strings.TrimSpace(string(data)), nil
}

func startMPVPaper(path string) error {
	args := []string{
		"-o", "loop panscan=1.0 background-color='#222222' mute=yes config=no input-ipc-server=" + MpvSocketPath,
		"*", path,
	}
	cmd := exec.Command("mpvpaper", args...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	return cmd.Start()
}

func getWorkspaceClients(workspace int) (bool, error) {
	socket := fmt.Sprintf("%s/hypr/%s/.socket.sock", os.Getenv("XDG_RUNTIME_DIR"), os.Getenv("HYPRLAND_INSTANCE_SIGNATURE"))
	conn, err := net.Dial("unix", socket) // ignore the err
	if err != nil {
		return false, err
	}
	defer conn.Close()

	// Send ipc client request
	fmt.Fprint(conn, "j/clients")

	var clients []Client
	json.NewDecoder(conn).Decode(&clients)

	// Check if there are no non-floating clients in the workspace
	for _, c := range clients {
		if c.Workspace.ID == workspace && !c.Floating {
			return false, nil
		}
	}
	return true, nil
}

func sendMPVCmd(paused bool) {
	state := "no"
	if paused {
		state = "yes"
	}
	conn, err := net.Dial("unix", MpvSocketPath)
	if err != nil {
		fmt.Println("mpv socket error:", err)
		return
	}
	defer conn.Close()
	fmt.Fprintf(conn, "set pause %s\n", state)
}
