package main

import (
	"dotfiles/pkg/log"
	"log/slog"
	"os"
	"time"

	"github.com/carapace-sh/carapace"
	"github.com/spf13/cobra"
)

var (
	format string
	quiet  bool
	Format = "%.1B"
)

func init() {
	cmd.Flags().StringVarP(&format, "format", "f", "B", `Format for speed
"M" for binary byte (KiB/s, MiB/s...)
"m" for binary bit (Kibps, Mibps...)
"B" for si byte (KB/s, MB/s...)
"b" for si bit (Kbps, Mbps...)`)

	cmd.Flags().BoolVarP(&quiet, "quiet", "q", false, "Suppress all logs")
}

var cmd = &cobra.Command{
	Use:   "netspeed",
	Short: "Monitor network speed",
	PreRun: func(cmd *cobra.Command, args []string) {
		if quiet {
			log.Setup(slog.LevelError + 1)
		} else {
			log.Setup(slog.LevelInfo)
		}

		switch format {
		case "M":
			Format = "%.1M/s"
		case "m":
			Format = "%.1mps"
		case "B", "":
			Format = "%.1B/s"
		case "b":
			Format = "%.1bps"
		default:
			slog.Error("Invalid speed format")
			os.Exit(1)
		}
	},
	Run: func(cmd *cobra.Command, args []string) {
		start := time.Now()
		before, err := ParseNetDev()
		if err != nil {
			slog.Error("Failed to parse net dev", "error", err)
			os.Exit(1)
		}

		before, iface, err := CalcSpeed(before, "", time.Since(start))
		if err != nil {
			slog.Error("Error calculating speed", "error", err)
		}

		interval := 2 * time.Second

		ticker := time.NewTicker(interval)
		defer ticker.Stop()
		for {
			<-ticker.C
			before, iface, err = CalcSpeed(before, iface, interval)
			if err != nil {
				slog.Error("Error calculating speed", "error", err)
			}
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
