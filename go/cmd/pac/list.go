package main

import (
	"fmt"
	"os"
	"os/exec"

	"github.com/spf13/cobra"
)

func init() {
	pacCmd.AddCommand(listCmd)
}

var listCmd = &cobra.Command{
	Use:   "list",
	Short: "Lists all installed packages with interactive fuzzy search",
	RunE: func(cmd *cobra.Command, args []string) error {
		// Check if fzf is installed
		if _, err := exec.LookPath("fzf"); err != nil {
			return fmt.Errorf("fzf command isn't installed")
		}

		// Create the command pipeline
		pacmanQq := exec.Command("pacman", "-Qq")
		fzf := exec.Command("fzf", "--preview", "pacman -Qil {}", "--bind", "enter:execute(pacman -Qil {} | less)")

		// Connect the pipes
		fzf.Stdin, _ = pacmanQq.StdoutPipe()
		fzf.Stdout = os.Stdout
		fzf.Stderr = os.Stderr

		// Start the commands
		if err := fzf.Start(); err != nil {
			return fmt.Errorf("failed to start fzf: %w", err)
		}
		if err := pacmanQq.Start(); err != nil {
			return fmt.Errorf("failed to start pacman: %w", err)
		}

		// Wait for completion
		if err := pacmanQq.Wait(); err != nil {
			return fmt.Errorf("pacman failed: %w", err)
		}
		return fzf.Wait()
	},
}
