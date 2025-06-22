#!/usr/bin/env scriptisto

package main

// scriptisto-begin
// script_src: main.go
// build_once_cmd: go mod tidy
// build_cmd: go build -o eww-hyprland
// replace_shebang_with: //
// target_bin: ./eww-hyprland
// files:
//  - path: go.mod
//    content: |
//      module eww
//
//      go 1.24
// scriptisto-end

import (
	"bufio"
	"encoding/json"
	"fmt"
	"net"
	"os"
	"sort"
	"strconv"
	"strings"
	"time"
)

var (
	XdgRuntime  = os.Getenv("XDG_RUNTIME_DIR")
	HIS         = os.Getenv("HYPRLAND_INSTANCE_SIGNATURE")
	DataSocket  = fmt.Sprintf("%s/hypr/%s/.socket.sock", XdgRuntime, HIS)
	EventSocket = fmt.Sprintf("%s/hypr/%s/.socket2.sock", XdgRuntime, HIS)

	GetActiveWorkspace = []byte("j/activeworkspace")
	GetWorkspaces      = []byte("j/workspaces")
)

// RawWorkspace represents the workspace data from Hyprland
type RawWorkspace struct {
	ID    int    `json:"id"`
	Name  string `json:"name"`
	Title string `json:"lastwindowtitle"`
}

// Workspace represents the formatted workspace data for output
type Workspace struct {
	ID     int    `json:"id"`
	Name   string `json:"name"`
	Title  string `json:"hover"`
	Active bool   `json:"active"`
}

type ActiveWorkspace struct {
	ID int `json:"id"`
}

// GetActiveWorkspaceID gets the currently active workspace ID
func GetActiveWorkspaceID() (int, error) {
	conn, err := net.Dial("unix", DataSocket)
	if err != nil {
		return 0, err
	}

	_, err = conn.Write(GetActiveWorkspace)
	if err != nil {
		return 0, err
	}

	var result ActiveWorkspace
	if err := json.NewDecoder(conn).Decode(&result); err != nil {
		return 0, err
	}

	return result.ID, nil
}

// PrintWorkspaces outputs the workspaces as JSON
func PrintWorkspaces(id int) error {
	// Go code is too fast... Thus, when changing to workspace, the list of workspace
	// gets printed before destroying of empty workspace. The hyprland ipc does send
	// destroywindow event. But sleep is easier and requies less processing.
	time.Sleep(50 * time.Millisecond)

	conn, err := net.Dial("unix", DataSocket)
	if err != nil {
		return err
	}

	_, err = conn.Write(GetWorkspaces)
	if err != nil {
		return err
	}

	var raw []RawWorkspace
	if err := json.NewDecoder(conn).Decode(&raw); err != nil {
		return err
	}

	workspaces := make([]Workspace, len(raw))
	for i, r := range raw {
		active := r.ID == id
		workspaces[i] = Workspace{
			ID:     r.ID,
			Name:   r.Name,
			Title:  r.Title,
			Active: active,
		}
	}

	// Sort by ID
	sort.Slice(workspaces, func(i, j int) bool {
		return workspaces[i].ID < workspaces[j].ID
	})

	return json.NewEncoder(os.Stdout).Encode(workspaces)
}

func main() {
	// Get and print initial workspace state
	activeID, err := GetActiveWorkspaceID()
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error getting active workspace ID: %v\n", err)
		os.Exit(1)
	}

	if err := PrintWorkspaces(activeID); err != nil {
		fmt.Fprintf(os.Stderr, "Error printing workspaces: %v\n", err)
		os.Exit(1)
	}

	conn, err := net.Dial("unix", EventSocket)
	if err != nil {
		panic(err)
	}
	defer conn.Close()

	// Listen for events
	scanner := bufio.NewScanner(conn)
	for scanner.Scan() {
		line := scanner.Text()
		after, ok := strings.CutPrefix(line, "workspacev2>>")
		if !ok {
			continue
		}

		idStr := strings.SplitN(after, ",", 2)[0]
		id, err := strconv.Atoi(idStr)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error parsing workspace ID '%s': %v\n", idStr, err)
			continue
		}

		if err := PrintWorkspaces(id); err != nil {
			fmt.Fprintf(os.Stderr, "Error printing workspaces: %v\n", err)
		}
	}

	if err := scanner.Err(); err != nil {
		panic(err)
	}
}
