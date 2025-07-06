package main

import (
	"dotfiles/pkg/diskspace"
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
	"slices"
	"time"
)

type Delta struct {
	Interface string `json:"interface"`
	Down      string `json:"down"`
	Up        string `json:"up"`
	Change    string `json:"change"`
	Wireless  bool   `json:"wireless"`
	Table     string `json:"table,omitzero"` // You can customize this

	GraphUp     float64 `json:"graph_up"`
	GraphDown   float64 `json:"graph_down"`
	GraphChange float64 `json:"graph_change"`

	drx, dtx, change diskspace.Diskspace
}

func CalcSpeed(before map[string]NetStat, lastIFace string, interval time.Duration) (map[string]NetStat, string, error) {
	after, err := ParseNetDev()
	if err != nil {
		return nil, "", err
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

			drx: drx, dtx: dtx, change: change,
		}
		allDeltas = append(allDeltas, d)
	}

	if len(allDeltas) == 0 {
		return after, "", nil
	}

	noZero := slices.ContainsFunc(allDeltas, func(d Delta) bool {
		return d.change != 0
	})

	speed := allDeltas[0]

	if noZero {
		slices.SortFunc(allDeltas, func(a, b Delta) int {
			return int(b.change - a.change)
		})
		speed = allDeltas[0]
	} else {
		for d := range slices.Values(allDeltas) {
			if d.Interface == lastIFace {
				speed = d
				break
			}
		}
	}

	highest := float64(max(speed.drx, speed.dtx, speed.change, 1*diskspace.Mb)) * 1.1
	speed.GraphDown = float64(speed.drx) * 100 / highest
	speed.GraphUp = float64(speed.dtx) * 100 / highest
	speed.GraphChange = float64(speed.change) * 100 / highest

	json.NewEncoder(os.Stdout).Encode(speed)

	return after, speed.Interface, nil
}
