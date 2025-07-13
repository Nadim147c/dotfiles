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

	"github.com/spf13/pflag"
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

func init() {
	quiet := pflag.BoolP("quiet", "q", false, "Suppress all logs")
	pflag.Parse()

	if *quiet {
		log.Setup(slog.LevelError + 1)
	} else {
		log.Setup(slog.LevelDebug)
	}
}

func main() {
	// Write the cava config file
	if err := os.WriteFile(ConfigPath, []byte(CavaConfig), 0644); err != nil {
		slog.Error("Failed to write config file", slog.String("path", ConfigPath), slog.Any("error", err))
		return
	}

	slog.Info("Starting cava", slog.String("config", ConfigPath))

	// Run cava
	cmd := exec.CommandContext(context.Background(), "cava", "-p", ConfigPath)
	stdout, err := cmd.StdoutPipe()
	if err != nil {
		slog.Error("Failed to get stdout pipe", slog.Any("error", err))
		return
	}

	if err := cmd.Start(); err != nil {
		slog.Error("Failed to start cava", slog.Any("error", err))
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
		slog.Error("Scanner error", slog.Any("error", err))
	}

	if err := cmd.Wait(); err != nil {
		slog.Error("Cava exited with error", slog.Any("error", err))
	}
}
