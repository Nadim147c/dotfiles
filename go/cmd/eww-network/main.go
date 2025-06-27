package main

import (
	"bufio"
	"dotfiles/pkg/diskspace"
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
	"slices"
	"strconv"
	"strings"
	"time"

	"github.com/spf13/pflag"
)

var Format = "%.1B"

func init() {
	format := pflag.StringP("format", "f", "B", `Format for speed
"K" for binary byte (KiB/s, MiB/s...)
"k" for binary bit (Kibps, Mibps...)
"B" for si byte (KB/s, MB/s...)
"b" for si bit (Kbps, Mbps...)
`)

	pflag.Parse()

	switch *format {
	case "K":
		Format = "%.1K/s"
	case "k":
		Format = "%.1kps"
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
	before, err := parseNetDev()
	if err != nil {
		panic(err)
	}

	before, err = calcSpeed(before, time.Since(start))
	if err != nil {
		fmt.Fprintln(os.Stderr, "Error:", err)
	}

	interval := 2 * time.Second

	ticker := time.NewTicker(interval)
	for {
		<-ticker.C
		before, err = calcSpeed(before, interval)
		if err != nil {
			fmt.Fprintln(os.Stderr, "Error:", err)
		}
	}
}

type NetStat struct {
	Interface string
	Rx, Tx    diskspace.Diskspace
}

type Delta struct {
	Interface string `json:"interface"`
	Down      string `json:"down"`
	Up        string `json:"up"`
	Change    string `json:"change"`
	Wireless  bool   `json:"wireless"`
	Table     string `json:"table,omitzero"` // You can customize this
	delta     diskspace.Diskspace
}

func parseNetDev() (map[string]NetStat, error) {
	file, err := os.Open("/proc/net/dev")
	if err != nil {
		return nil, err
	}
	defer file.Close()

	stats := map[string]NetStat{}
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if !strings.Contains(line, ":") {
			continue
		}

		parts := strings.Split(line, ":")
		iface := strings.TrimSpace(parts[0])
		fields := strings.Fields(parts[1])
		if len(fields) < 9 {
			continue
		}

		rx, _ := strconv.ParseInt(fields[0], 10, 64)
		tx, _ := strconv.ParseInt(fields[8], 10, 64)
		stats[iface] = NetStat{
			Interface: iface,

			Rx: diskspace.Diskspace(rx),
			Tx: diskspace.Diskspace(tx),
		}
	}

	return stats, nil
}

func calcSpeed(before map[string]NetStat, interval time.Duration) (map[string]NetStat, error) {
	after, err := parseNetDev()
	if err != nil {
		return nil, err
	}

	var allDeltas []Delta

	for iface, b := range before {
		a, ok := after[iface]
		if !ok {
			continue
		}

		durationSec := float64(interval) / float64(time.Second)

		drx := diskspace.Diskspace(float64(a.Rx-b.Rx) / durationSec)
		dtx := diskspace.Diskspace(float64(a.Tx-b.Tx) / durationSec)
		change := drx + dtx

		wireless := false
		if _, err := os.Stat(filepath.Join("/sys/class/net", iface, "wireless")); err == nil {
			wireless = true
		}

		d := Delta{
			Interface: iface,
			Down:      fmt.Sprintf(Format, drx),
			Up:        fmt.Sprintf(Format, dtx),
			Change:    fmt.Sprintf(Format, change),
			Wireless:  wireless,
			delta:     change,
		}
		allDeltas = append(allDeltas, d)
	}
	if len(allDeltas) == 0 {
		return after, nil
	}

	slices.SortFunc(allDeltas, func(a, b Delta) int {
		return int(b.delta - a.delta)
	})

	rows := make([]string, len(allDeltas))
	for i, d := range allDeltas {
		row := fmt.Sprintf("%s:\t  %s\t  %s\t  %s", d.Interface, d.Change, d.Down, d.Up)
		rows[i] = row
	}

	speed := allDeltas[0]
	speed.Table = strings.Join(rows, "\n")

	json.NewEncoder(os.Stdout).Encode(speed)

	return after, nil
}
