#!/usr/bin/env scriptisto

package main

// scriptisto-begin
// script_src: main.go
// build_once_cmd: go mod tidy
// build_cmd: go build -o mpvpaper-watcher
// target_bin: mpvpaper-watcher
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

type Client struct {
	Workspace struct {
		ID int `json:"id"`
	} `json:"workspace"`
	Floating bool `json:"floating"`
}

var (
	MpvSocket      = "/tmp/mpvpaper.sock"
	XdgRuntime     = os.Getenv("XDG_RUNTIME_DIR")
	His            = os.Getenv("HYPRLAND_INSTANCE_SIGNATURE")
	HyprlandSocket = fmt.Sprintf("%s/hypr/%s/.socket2.sock", XdgRuntime, His)
)

func main() {
	// Attempt wallpaper restore
	wallpaperPath, err := GetWallpaperPath()
	if err != nil {
		fmt.Fprintln(os.Stderr, "Failed to read wallpaper path:", err)
		os.Exit(1)
	}

	if err := StartMpvPaper(wallpaperPath); err != nil {
		fmt.Fprintln(os.Stderr, "Failed to start mpvpaper:", err)
	}

	conn, err := net.Dial("unix", HyprlandSocket)
	if err != nil {
		fmt.Println("Failed to connect Hyprland socket:", err)
		os.Exit(1)
	}
	defer conn.Close()

	workspace := 5 // fallback
	scanner := bufio.NewScanner(conn)
	for scanner.Scan() {
		line := scanner.Text()
		if after, ok := strings.CutPrefix(line, "workspacev2>>"); ok {
			id := strings.Split(after, ",")[0]
			fmt.Sscanf(id, "%d", &workspace)
		}

		noClients, err := GetWorkspaceClients(workspace)
		if err != nil {
			fmt.Println("Error checking clients:", err)
			continue
		}

		if noClients {
			SendMPVCmd(false)
		} else {
			SendMPVCmd(true)
		}
	}
}

func GetWallpaperPath() (string, error) {
	data, err := os.ReadFile(os.ExpandEnv("$HOME/.cache/wallpaper"))
	if err != nil {
		return "", err
	}
	return strings.TrimSpace(string(data)), nil
}

func StartMpvPaper(path string) error {
	args := []string{
		"-o", "loop panscan=1.0 background-color='#222222' mute=yes config=no input-ipc-server=" + MpvSocket,
		"*", path,
	}
	cmd := exec.Command("mpvpaper", args...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	return cmd.Start()
}

var GetHyprlandClients = []byte("j/clients")

func GetWorkspaceClients(workspace int) (bool, error) {
	socket := fmt.Sprintf("%s/hypr/%s/.socket.sock", os.Getenv("XDG_RUNTIME_DIR"), os.Getenv("HYPRLAND_INSTANCE_SIGNATURE"))
	conn, err := net.Dial("unix", socket) // ignore the err
	if err != nil {
		return false, err
	}
	defer conn.Close()

	_, err = conn.Write(GetHyprlandClients)
	if err != nil {
		return false, err
	}

	var clients []Client
	if err := json.NewDecoder(conn).Decode(&clients); err != nil {
		return false, err
	}

	// Check if there are no non-floating clients in the workspace
	for _, c := range clients {
		if c.Workspace.ID == workspace && !c.Floating {
			return false, nil
		}
	}
	return true, nil
}

var (
	Pause = []byte("set pause yes\n")
	Play  = []byte("set pause no\n")
)

func SendMPVCmd(paused bool) error {
	conn, err := net.Dial("unix", MpvSocket)
	if err != nil {
		return err
	}
	defer conn.Close()
	if paused {
        _, err = conn.Write(Pause)
        return err
	}
    _, err = conn.Write(Play)
    return err
}
