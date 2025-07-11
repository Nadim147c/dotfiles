package main

import (
	"dotfiles/pkg/log"
	"log/slog"
	"time"

	"github.com/spf13/pflag"
)

var Format = "%.1B"

func init() {
	format := pflag.StringP("format", "f", "B", `Format for speed
"M" for binary byte (KiB/s, MiB/s...)
"m" for binary bit (Kibps, Mibps...)
"B" for si byte (KB/s, MB/s...)
"b" for si bit (Kbps, Mbps...)
`)

	quite := pflag.BoolP("quite", "q", false, "Subpress all logs")

	pflag.Parse()

	if *quite {
		log.Setup(slog.LevelError + 1)
	} else {
		log.Setup(slog.LevelInfo)
	}

	switch *format {
	case "M":
		Format = "%.1M/s"
	case "m":
		Format = "%.1mps"
	case "B", "":
		Format = "%.1B/s"
	case "b":
		Format = "%.1bps"
	default:
		panic("Invalid speed format")
	}
}

func main() {
	start := time.Now()
	before, err := ParseNetDev()
	if err != nil {
		slog.Error("Failed to parse net dev", "error", err)
		panic(err)
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
}
