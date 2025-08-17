package main

import (
	"fmt"
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
		fmt.Println("Usage: fork <command> [args...]")
		os.Exit(0)
	}

	cmd := exec.Command(os.Args[1], os.Args[2:]...)

	// syscall for fork
	cmd.SysProcAttr = &syscall.SysProcAttr{Setsid: true}

	if err := cmd.Start(); err != nil {
		log.Fatalf("Failed to start process: %v", err)
	}
	os.Exit(0)
}
