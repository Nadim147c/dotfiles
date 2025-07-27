// Source: https://github.com/ankkax/hyprland/blob/main/eww/bar/scripts/cava-internal.sh

package main

import (
	"bufio"
	"context"
	"dotfiles/pkg/log"
	"fmt"
	"log/slog"
	"os"
	"os/exec"
	"strings"

	"github.com/carapace-sh/carapace"
	"github.com/spf13/cobra"
)

const (
	ConfigPath = "/tmp/eww-cava-conf"
	CavaConfig = `[general]
bars = 10
[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
`
)

var quiet bool

func init() {
	cmd.Flags().BoolVarP(&quiet, "quiet", "q", false, "Suppress all logs")
}

var cmd = &cobra.Command{
	Use:   "eww-cava",
	Short: "Run cava with custom config and parse output",
	PreRun: func(cmd *cobra.Command, args []string) {
		if quiet {
			log.Setup(slog.LevelError + 100)
		} else {
			log.Setup(slog.LevelDebug)
		}
	},
	Run: func(cmd *cobra.Command, args []string) {
		// Write the cava config file
		if err := os.WriteFile(ConfigPath, []byte(CavaConfig), 0644); err != nil {
			slog.Error("Failed to write config file", "path", ConfigPath, "error", err)
			return
		}

		slog.Info("Starting cava", "config", ConfigPath)

		// Run cava
		cmdExec := exec.CommandContext(context.Background(), "cava", "-p", ConfigPath)
		stdout, err := cmdExec.StdoutPipe()
		if err != nil {
			slog.Error("Failed to get stdout pipe", "error", err)
			return
		}

		if err := cmdExec.Start(); err != nil {
			slog.Error("Failed to start cava", "error", err)
			return
		}

		// Unicode bars
		bar := []rune("▁▂▃▄▅▆▇█")

		scanner := bufio.NewScanner(stdout)
		for scanner.Scan() {
			line := scanner.Text()
			var output strings.Builder
			for _, ch := range line {
				if ch >= '0' && ch <= '7' {
					output.WriteRune(bar[ch-'0'])
				}
			}
			fmt.Println(output.String())
		}

		if err := scanner.Err(); err != nil {
			slog.Error("Scanner error", "error", err)
		}

		if err := cmdExec.Wait(); err != nil {
			slog.Error("Cava exited with error", "error", err)
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
