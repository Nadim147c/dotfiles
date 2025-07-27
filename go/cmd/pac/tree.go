package main

import (
	"fmt"
	"os"
	"os/exec"

	"github.com/carapace-sh/carapace"
	"github.com/spf13/cobra"
)

func init() {
	pacCmd.AddCommand(treeCmd)
	carapace.Gen(treeCmd).PositionalCompletion(CarapaceInstalledPackage)
}

var treeCmd = &cobra.Command{
	Use:   "tree [package]",
	Short: "Displays the dependency tree of a specified installed package",
	Args:  cobra.ExactArgs(1),
	RunE: func(cmd *cobra.Command, args []string) error {
		// Check if pactree is installed
		if _, err := exec.LookPath("pactree"); err != nil {
			return fmt.Errorf("pactree command isn't installed. Install \"pacman-contrib\" package")
		}

		// Create the command pipeline
		pactreeCmd := exec.Command("pactree", args[0])
		lessCmd := exec.Command("less")

		// Connect the pipes
		lessCmd.Stdin, _ = pactreeCmd.StdoutPipe()
		lessCmd.Stdout = os.Stdout
		lessCmd.Stderr = os.Stderr

		// Start the commands
		if err := lessCmd.Start(); err != nil {
			return fmt.Errorf("failed to start less: %w", err)
		}
		if err := pactreeCmd.Start(); err != nil {
			return fmt.Errorf("failed to start pactree: %w", err)
		}

		// Wait for completion
		if err := pactreeCmd.Wait(); err != nil {
			return fmt.Errorf("pactree failed: %w", err)
		}
		return lessCmd.Wait()
	},
}
