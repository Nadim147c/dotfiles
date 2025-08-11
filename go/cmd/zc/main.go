package main

import (
	"bytes"
	"dotfiles/pkg/log"
	"fmt"
	"log/slog"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"slices"
	"strings"

	"github.com/carapace-sh/carapace"
	"github.com/spf13/cobra"
)

var quiet bool

func init() {
	cmd.Flags().BoolVarP(&quiet, "quiet", "q", false, "Suppress all logs")
}

var cmd = &cobra.Command{
	Use:   "zc",
	Short: "Create or attach to a zellij session for a git repository",
	PersistentPreRun: func(cmd *cobra.Command, args []string) {
		if quiet {
			log.Setup(slog.LevelError + 100)
		} else {
			log.Setup(slog.LevelDebug)
		}
	},
	Run: func(cmd *cobra.Command, args []string) {
		if err := zellijCheck(); err != nil {
			slog.Error("Zellij check failed", "error", err)
			os.Exit(1)
		}

		home, err := os.UserHomeDir()
		if err != nil {
			slog.Error("Could not get home directory", "error", err)
			os.Exit(1)
		}

		repos, err := findGitRepos(home, "git")
		if err != nil {
			slog.Error("Could not find git repositories", "error", err)
			os.Exit(1)
		}

		if len(repos) == 0 {
			slog.Error("Git directory list is empty")
			os.Exit(1)
		}

		// 3. Present selection with fzf
		selected, err := selectRepo(repos)
		if err != nil {
			slog.Error("Selection failed", "error", err)
			os.Exit(1)
		}

		if selected == "" {
			slog.Error("No session selected")
			os.Exit(1)
		}

		selected = filepath.Join(home, selected)
		name := sanitizeName(filepath.Base(selected))
		absPath, err := filepath.Abs(selected)
		if err != nil {
			slog.Error("Could not get absolute path", "path", selected, "error", err)
			os.Exit(1)
		}

		// 5. Add to zoxide
		addToZoxide(absPath)

		// 6. Generate layout
		layoutFile, err := generateLayout(absPath)
		if err != nil {
			slog.Error("Could not generate layout", "error", err)
			os.Exit(1)
		}
		defer os.Remove(layoutFile)

		// 7. Create or attach to session
		sessions := listZellijSessions()

		if slices.Contains(sessions, name) {
			attachSession(name)
		} else {
			createSession(name, layoutFile)
		}
	},
}

func main() {
	carapace.Gen(cmd).Standalone()
	if err := cmd.Execute(); err != nil {
		slog.Error("Command execution failed", "error", err)
		os.Exit(1)
	}
}

func findGitRepos(base string, dirs ...string) ([]string, error) {
	cmd := exec.Command("fd", ".",
		"--base-directory", base,
		"--max-depth=1",
		"--min-depth=1",
		"--type=d",
		"--color=always",
	)
	cmd.Args = append(cmd.Args, dirs...)

	output, err := cmd.Output()
	if err != nil {
		return nil, fmt.Errorf("fd command failed: %w", err)
	}
	return strings.Split(strings.TrimSpace(string(output)), "\n"), nil
}

// Helper functions
func zellijCheck() error {
	if _, err := exec.LookPath("zellij"); err != nil {
		return fmt.Errorf("zellij multiplexer doesn't exist: %w", err)
	}

	if os.Getenv("ZELLIJ") != "" {
		return fmt.Errorf("this operation isn't allowed inside a session")
	}

	return nil
}

func selectRepo(repos []string) (string, error) {
	var buf bytes.Buffer
	cmd := exec.Command("fzf", "--ansi")
	cmd.Stdin = strings.NewReader(strings.Join(repos, "\n"))
	cmd.Stdout = &buf
	cmd.Stderr = os.Stderr

	if err := cmd.Run(); err != nil {
		if exitErr, ok := err.(*exec.ExitError); ok && exitErr.ExitCode() == 130 {
			// User canceled
			return "", nil
		}
		return "", fmt.Errorf("fzf command failed: %w", err)
	}

	return strings.TrimSpace(buf.String()), nil
}

func sanitizeName(name string) string {
	reg := regexp.MustCompile(`[\.\s]+`)
	return reg.ReplaceAllString(name, "-")
}

func addToZoxide(path string) {
	if _, err := exec.LookPath("zoxide"); err == nil {
		cmd := exec.Command("zoxide", "add", path)
		cmd.Run()
	}
}

func generateLayout(cwd string) (string, error) {
	statusPath := filepath.Join(os.Getenv("HOME"), ".config", "zellij", "status.kdl")
	statusBar, err := os.ReadFile(statusPath)
	if err != nil {
		return "", fmt.Errorf("could not read status.kdl: %w", err)
	}

	layout := fmt.Sprintf(`
layout {
    cwd "%s"
    tab name="Neovim" focus=true hide_floating_panes=true {
        pane command="nvim" cwd="%s"
    }
    tab name="Shell" hide_floating_panes=true {
        pane cwd="%s"
    }
    default_tab_template {
        %s
        children
    }
}
`, cwd, cwd, cwd, string(statusBar))

	file, err := os.CreateTemp("", "zellij-layout-*.kdl")
	if err != nil {
		return "", fmt.Errorf("could not create temp file: %w", err)
	}

	if _, err := file.WriteString(layout); err != nil {
		file.Close()
		os.Remove(file.Name())
		return "", fmt.Errorf("could not write to temp file: %w", err)
	}
	file.Close()

	return file.Name(), nil
}

func listZellijSessions() []string {
	cmd := exec.Command("zellij", "list-sessions", "--short")
	output, err := cmd.Output()
	if err != nil {
		return nil
	}

	sessions := strings.Split(strings.TrimSpace(string(output)), "\n")
	if len(sessions) == 1 && sessions[0] == "" {
		return []string{}
	}
	return sessions
}

func attachSession(name string) {
	cmd := exec.Command("zellij", "attach", name)
	cmd.Stdin = os.Stdin
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Run()
}

func createSession(name, layoutFile string) {
	cmd := exec.Command("zellij", "-s", name, "-n", layoutFile)
	cmd.Stdin = os.Stdin
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Run()
}
