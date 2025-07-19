package main

import (
	"log/slog"
	"os"
	"os/exec"
	"time"
)

var (
	longTime = 100 * 24 * time.Hour
	timer    = time.NewTimer(longTime)
)

func HandleWorkspace(name string) {
	// Open the workspace
	openCmd := exec.Command("eww", "open", "hyprland_ws_name", "--arg", "name="+name)
	openCmd.Stdout = os.Stderr
	openCmd.Stderr = os.Stderr
	if err := openCmd.Run(); err != nil {
		slog.Error("Failed to open workspace", "error", err)
		return
	}
	slog.Info("Workspace opened")
	timer.Reset(time.Second)

	go func() {
		for range timer.C {
			err := exec.Command("eww", "close", "hyprland_ws_name").Run()
			if err != nil {
				slog.Error("Failed to close hyprland_ws_name")
			}
			timer.Reset(longTime)
		}
	}()
}
