package main

import (
	"fmt"
	"os/exec"

	"github.com/spf13/cobra"
)

func init() {
	pacCmd.AddCommand(pruneCmd)
}

var pruneCmd = &cobra.Command{
	Use:   "prune",
	Short: "Removes orphaned packages after confirmation",
	RunE: func(cmd *cobra.Command, args []string) error {
		// Get orphaned packages
		orphans, err := getOrphanedPackages()
		if err != nil {
			return err
		}

		if len(orphans) == 0 {
			return fmt.Errorf("no unused dependencies found")
		}

		return NewCommand("pacman").Args("-Rs").Args(orphans...).Execute()
	},
}

func getOrphanedPackages() ([]string, error) {
	cmd := exec.Command("pacman", "-Qtdq")
	output, err := cmd.Output()
	if err != nil {
		// pacman returns exit code 1 when no orphans found
		if exitErr, ok := err.(*exec.ExitError); ok && exitErr.ExitCode() == 1 {
			return []string{}, nil
		}
		return nil, fmt.Errorf("failed to get orphaned packages: %w", err)
	}

	if len(output) == 0 {
		return []string{}, nil
	}

	return Lines(output), nil
}
