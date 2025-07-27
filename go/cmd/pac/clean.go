package main

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"

	"github.com/carapace-sh/carapace"
	"github.com/spf13/cobra"
)

func init() {
	pacCmd.AddCommand(cleanCmd)
	carapace.Gen(cleanCmd).PositionalAnyCompletion(carapace.ActionDirectories())
}

var cleanCmd = &cobra.Command{
	Use:   "clean [cache_path...]",
	Short: "Cleans cached files from pacman and AUR helpers",
	RunE: func(cmd *cobra.Command, args []string) error {
		// Ask for confirmation
		fmt.Print("You are about to delete pacman and AUR caches. Are you sure? [y/N] ")
		var confirm string
		fmt.Scanln(&confirm)
		if strings.ToLower(confirm) != "y" {
			return nil
		}

		fmt.Println("Clearing pacman caches...")

		// Clean pacman cache
		if err := NewCommand("paccache").Args("-vrk2").Execute(); err != nil {
			return fmt.Errorf("failed to clean installed packages cache: %w", err)
		}
		if err := NewCommand("paccache").Args("-vruk0").Execute(); err != nil {
			return fmt.Errorf("failed to clean uninstalled packages cache: %w", err)
		}

		// Get AUR cache directories
		aurCacheDirs, err := getAurCacheDirs(args)
		if err != nil {
			return err
		}

		// Clean AUR caches
		if len(aurCacheDirs) > 0 {
			if err := NewCommand("paccache").Args("-vrk2").Args(aurCacheDirs...).Execute(); err != nil {
				return fmt.Errorf("failed to clean AUR installed packages cache: %w", err)
			}

			if err := NewCommand("paccache").Args("-vruk0", "-c").Args(aurCacheDirs...).Execute(); err != nil {
				return fmt.Errorf("failed to clean AUR uninstalled packages cache: %w", err)
			}

			// Remove empty directories
			for _, dir := range aurCacheDirs {
				if isEmpty, err := isDirEmpty(dir); err == nil && isEmpty {
					fmt.Printf("Clearing the cache from '%s'\n", dir)
					if err := os.RemoveAll(dir); err != nil {
						return fmt.Errorf("failed to remove directory %s: %w", dir, err)
					}
				}
			}
		}

		return nil
	},
}

func getAurCacheDirs(args []string) ([]string, error) {
	var dirs []string

	// Check standard AUR helper cache directories
	home, err := os.UserHomeDir()
	if err != nil {
		return nil, fmt.Errorf("failed to get home directory: %w", err)
	}

	standardDirs := []string{
		filepath.Join(home, ".cache", "yay"),
		filepath.Join(home, ".cache", "paru", "clone"),
	}

	for _, dir := range standardDirs {
		if _, err := os.Stat(dir); err == nil {
			subdirs, err := getSubdirectories(dir)
			if err != nil {
				return nil, err
			}
			dirs = append(dirs, subdirs...)
		}
	}

	// Check additional provided cache paths
	for _, arg := range args {
		expandedPath := expandPath(arg)
		if _, err := os.Stat(expandedPath); err == nil {
			subdirs, err := getSubdirectories(expandedPath)
			if err != nil {
				return nil, err
			}
			dirs = append(dirs, subdirs...)
		}
	}

	return dirs, nil
}

func getSubdirectories(dir string) ([]string, error) {
	entries, err := os.ReadDir(dir)
	if err != nil {
		return nil, fmt.Errorf("failed to read directory %s: %w", dir, err)
	}

	var subdirs []string
	for _, entry := range entries {
		if entry.IsDir() {
			subdirs = append(subdirs, filepath.Join(dir, entry.Name()))
		}
	}
	return subdirs, nil
}

func isDirEmpty(dir string) (bool, error) {
	entries, err := os.ReadDir(dir)
	if err != nil {
		return false, err
	}

	for _, entry := range entries {
		if strings.HasSuffix(entry.Name(), ".tar.zst") {
			return false, nil
		}
	}
	return true, nil
}

func expandPath(path string) string {
	if strings.HasPrefix(path, "~/") {
		home, _ := os.UserHomeDir()
		return filepath.Join(home, path[2:])
	}
	return path
}
