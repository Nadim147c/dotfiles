package main

import (
	"log"
	"os"
	"os/exec"
	"slices"
	"syscall"
)

func main() {
	if len(os.Args) < 2 ||
		slices.Contains(os.Args, "--help") ||
		slices.Contains(os.Args, "-help") ||
		slices.Contains(os.Args, "_carapace") {
		log.Fatalf("Usage: fork <command> [args...]")
	}

	cmd := exec.Command(os.Args[1], os.Args[2:]...)

	// Detach the process from the terminal/session
	cmd.SysProcAttr = &syscall.SysProcAttr{Setsid: true}

	// Redirect all stdio to /dev/null
	devNull, err := os.OpenFile(os.DevNull, os.O_RDWR, 0)
	if err != nil {
		log.Fatalf("Failed to open /dev/null: %v", err)
	}
	defer devNull.Close()

	cmd.Stdin = devNull
	cmd.Stdout = devNull
	cmd.Stderr = devNull

	// Start the process (but do not wait)
	if err := cmd.Start(); err != nil {
		log.Fatalf("Failed to start process: %v", err)
	}

	// Exit immediately
	os.Exit(0)
}
