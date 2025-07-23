package main

import (
	"dotfiles/pkg/diskspace"
	"encoding/json"
	"fmt"
	"log/slog"
	"os"
	"path/filepath"
	"sync"
	"time"
)

type Delta struct {
	Interface string `json:"interface"`
	Down      string `json:"down"`
	Up        string `json:"up"`
	Change    string `json:"change"`
	Wireless  bool   `json:"wireless"`

	drx, dtx, change diskspace.Diskspace
}

var (
	wirelessCache   = make(map[string]bool)
	wirelessCacheMu sync.Mutex
)

func isWireless(iface string) bool {
	wirelessCacheMu.Lock()
	defer wirelessCacheMu.Unlock()

	if cached, ok := wirelessCache[iface]; ok {
		return cached
	}

	path := filepath.Join("/sys/class/net", iface, "wireless")
	_, err := os.Stat(path)
	wireless := err == nil
	wirelessCache[iface] = wireless
	return wireless
}

func CalcSpeed(before map[string]NetStat, lastIFace string, interval time.Duration) (map[string]NetStat, string, error) {
	after, err := ParseNetDev()
	if err != nil {
		slog.Error("Failed to parse network device stats", "error", err)
		return nil, "", err
	}

	var (
		firstDelta     *Delta
		maxDelta       *Delta
		foundLastIFace *Delta
	)

	const sec = diskspace.Diskspace(time.Second)
	duration := diskspace.Diskspace(interval)

	for iface, b := range before {
		a, ok := after[iface]
		if !ok {
			slog.Debug("Interface not found in current stats", "interface", iface)
			continue
		}

		drx := (a.Rx - b.Rx) * sec / duration
		dtx := (a.Tx - b.Tx) * sec / duration
		change := drx + dtx

		d := &Delta{
			Interface: iface,
			drx:       drx,
			dtx:       dtx,
			change:    change,
			Wireless:  isWireless(iface),
		}

		if firstDelta == nil {
			firstDelta = d
		}
		if iface == lastIFace {
			foundLastIFace = d
		}
		if change > 0 && (maxDelta == nil || change > maxDelta.change) {
			maxDelta = d
		}
	}

	if firstDelta == nil {
		slog.Warn("No network interfaces with traffic found")
		return after, "", nil
	}

	candidate := firstDelta
	switch {
	case maxDelta != nil:
		candidate = maxDelta
	case foundLastIFace != nil:
		candidate = foundLastIFace
	}

	candidate.Down = fmt.Sprintf(Format, candidate.drx)
	candidate.Up = fmt.Sprintf(Format, candidate.dtx)
	candidate.Change = fmt.Sprintf(Format, candidate.change)

	if err := json.NewEncoder(os.Stdout).Encode(candidate); err != nil {
		slog.Error("Failed to encode speed data", "error", err)
	}

	return after, candidate.Interface, nil
}
