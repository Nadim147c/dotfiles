package main

import (
	"bufio"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io/fs"
	"log"
	"net"
	"os"
	"os/exec"
	"slices"
	"strings"
	"time"

	"github.com/fsnotify/fsnotify"
)

type Client struct {
	Workspace struct {
		ID int `json:"id"`
	} `json:"workspace"`
	Floating bool `json:"floating"`
}

var (
	MpvSocket                 = "/tmp/mpvpaper.sock"
	XdgRuntime                = os.Getenv("XDG_RUNTIME_DIR")
	HyprlandInstanceSignature = os.Getenv("HYPRLAND_INSTANCE_SIGNATURE")
	HyprlandSocket            = fmt.Sprintf("%s/hypr/%s/.socket2.sock", XdgRuntime, HyprlandInstanceSignature)
)

func main() {
	ctx, cencel := context.WithCancel(context.Background())
	defer cencel()

	// Attempt wallpaper restore
	wallpaperPath, err := GetWallpaperPath()
	if err != nil {
		fmt.Fprintln(os.Stderr, "Failed to read wallpaper path:", err)
		os.Exit(1)
	}

	if err := StartMpvPaper(ctx, wallpaperPath); err != nil {
		fmt.Fprintln(os.Stderr, "Failed to start mpvpaper:", err)
	}

	conn, err := net.Dial("unix", HyprlandSocket)
	if err != nil {
		fmt.Println("Failed to connect Hyprland socket:", err)
		os.Exit(1)
	}
	defer conn.Close()

	go WatchWallpaper(ctx)

	events := []string{
		"activewindowv2",
		"closewindow",
		"workspacev2",
		"changefloatingmode",
		"fullscreen",
	}

	workspace := 5 // fallback
	scanner := bufio.NewScanner(conn)
	for scanner.Scan() {
		line := scanner.Text()
		event, data, found := strings.Cut(line, ">>")
		if !found {
			continue
		}

		if event == "workspacev2" {
			id := strings.Split(data, ",")[0]
			fmt.Sscanf(id, "%d", &workspace)
		}
		if !slices.Contains(events, event) {
			continue
		}

		noClients, err := GetWorkspaceClients(workspace)
		if err != nil {
			fmt.Println("Error checking clients:", err)
			continue
		}

		if noClients {
			ToggleMPVPaper(false)
		} else {
			ToggleMPVPaper(true)
		}
	}
}

func GetWallpaperPath() (string, error) {
	data, err := os.ReadFile(os.ExpandEnv("$HOME/.local/state/wallpaper.state"))
	if err != nil {
		return "", err
	}
	return strings.TrimSpace(string(data)), nil
}

// WatchWallpaper monitors a wallpaper state file and updates wallpaper when changed.
// It supports context cancellation for safe shutdown.
func WatchWallpaper(ctx context.Context) error {
	watcher, err := fsnotify.NewWatcher()
	if err != nil {
		return fmt.Errorf("creating watcher: %w", err)
	}
	defer watcher.Close()

	stateFile := os.ExpandEnv("$HOME/.local/state/wallpaper.state")

	if err := watcher.Add(stateFile); err != nil {
		return fmt.Errorf("add watcher: %w", err)
	}

	// Goroutine that listens for fsnotify events.
	done := make(chan struct{})
	go func() {
		defer close(done)
		for {
			select {
			case <-ctx.Done():
				log.Println("watcher: context cancelled, stopping...")
				return

			case event, ok := <-watcher.Events:
				if !ok {
					log.Println("watcher: events channel closed")
					return
				}
				if event.Has(fsnotify.Create) || event.Has(fsnotify.Write) {
					handleFileChange(event.Name)
				}

			case err, ok := <-watcher.Errors:
				if !ok {
					log.Println("watcher: errors channel closed")
					return
				}
				log.Printf("watcher error: %v\n", err)
			}
		}
	}()

	<-ctx.Done() // Wait until cancelled
	<-done       // Wait for watcher goroutine to finish
	return nil
}

// handleFileChange safely reads and applies wallpaper updates.
func handleFileChange(filename string) {
	var b []byte
	var err error

	// Retry a few times to avoid race condition with file writes.
	for range 3 {
		b, err = os.ReadFile(filename)
		if err == nil {
			break
		}
		if errors.Is(err, fs.ErrNotExist) {
			time.Sleep(100 * time.Millisecond)
			continue
		}
		log.Printf("error reading file %s: %v", filename, err)
		return
	}

	if err != nil {
		log.Printf("could not read wallpaper state after retries: %v", err)
		return
	}

	path := strings.TrimSpace(string(b))
	if path == "" {
		log.Println("wallpaper file is empty; ignoring")
		return
	}

	SendMpvPaperCommand(fmt.Sprintf("loadfile %q", path))
}

func StartMpvPaper(ctx context.Context, path string) error {
	args := []string{
		"-o", "loop panscan=1.0 background-color='#222222' mute=yes config=no input-ipc-server=" + MpvSocket,
		"*", path,
	}
	cmd := exec.CommandContext(ctx, "mpvpaper", args...)
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
	Pause = "set pause yes"
	Play  = "set pause no"
)

func ToggleMPVPaper(pause bool) error {
	cmd := Play
	if pause {
		cmd = Pause
	}
	return SendMpvPaperCommand(cmd)
}

func SendMpvPaperCommand(cmd string) error {
	conn, err := net.Dial("unix", MpvSocket)
	if err != nil {
		return err
	}
	defer conn.Close()
	_, err = fmt.Fprintln(conn, cmd)
	return err
}
