package main

import (
	"bufio"
	"bytes"
	"encoding/json"
	"log"
	"os"
	"slices"
	"strconv"
	"strings"
	"time"
)

const NetDev = "/proc/net/dev"

type Transmitted struct {
	Up, Down Datasize
}

type Stats map[string]Transmitted

type InterfaceStats struct {
	Name          string
	LastUpBytes   Datasize
	LastDownBytes Datasize
	UpDeltas      []Datasize
	DownDeltas    []Datasize
	AvgUp         Datasize
	AvgDown       Datasize
}

var _ json.Marshaler = (*InterfaceStats)(nil)

func (i InterfaceStats) MarshalJSON() ([]byte, error) {
	j := make(map[string]any)
	j["interface"] = i.Name

	j["up"] = i.AvgUp
	j["down"] = i.AvgDown
	j["total"] = i.AvgUp + i.AvgDown

	j["upString"] = i.AvgUp.String() + "/s"
	j["downString"] = i.AvgDown.String() + "/s"
	j["totalString"] = (i.AvgUp + i.AvgDown).String() + "/s"

	return json.Marshal(j)
}

type SpeedCalculator struct {
	Interfaces map[string]*InterfaceStats
	Current    InterfaceStats
}

func NewSpeedCalculator() *SpeedCalculator {
	return &SpeedCalculator{
		Interfaces: make(map[string]*InterfaceStats),
	}
}

func (sc *SpeedCalculator) parseNetDev() (Stats, error) {
	file, err := os.ReadFile(NetDev)
	if err != nil {
		return nil, err
	}

	currentStats := make(Stats)
	scanner := bufio.NewScanner(bytes.NewReader(file))

	// Skip the first two header lines
	scanner.Scan()
	scanner.Scan()

	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if line == "" {
			continue
		}

		// Split by colon to separate interface name from data
		parts := strings.Split(line, ":")
		if len(parts) < 2 {
			continue
		}

		ifaceName := strings.TrimSpace(parts[0])

		// Parse the data fields (bytes are the first field after interface name)
		dataFields := strings.Fields(parts[1])
		if len(dataFields) < 1 {
			continue
		}

		rxBytes, err := strconv.Atoi(dataFields[0])
		if err != nil {
			continue
		}

		txBytes, err := strconv.Atoi(dataFields[8])
		if err != nil {
			continue
		}
		currentStats[ifaceName] = Transmitted{
			Down: Datasize(rxBytes),
			Up:   Datasize(txBytes),
		}
	}

	return currentStats, nil
}

func average(s []Datasize) Datasize {
	if len(s) == 0 {
		return 0
	}
	var total Datasize
	for e := range slices.Values(s) {
		total += e
	}
	return total / Datasize(len(s))
}

func (sc *SpeedCalculator) updateDeltas(currentStats Stats) {
	for name := range sc.Interfaces {
		if _, exists := currentStats[name]; !exists {
			delete(sc.Interfaces, name)
		}
	}

	var maxDelta Datasize
	// Update existing interfaces and add new ones
	for name, transmitted := range currentStats {
		stats, exists := sc.Interfaces[name]
		if !exists {
			sc.Interfaces[name] = &InterfaceStats{
				Name:          name,
				LastUpBytes:   transmitted.Up,
				LastDownBytes: transmitted.Down,
				UpDeltas:      make([]Datasize, 3), // Buffer for last 3 deltas
				DownDeltas:    make([]Datasize, 3), // Buffer for last 3 deltas
			}
			continue
		}

		du := max(transmitted.Up-stats.LastUpBytes, 0)
		stats.UpDeltas = append(stats.UpDeltas[1:], du)
		stats.AvgUp = average(stats.UpDeltas)

		dd := max(transmitted.Down-stats.LastDownBytes, 0)
		stats.DownDeltas = append(stats.DownDeltas[1:], dd)
		stats.AvgDown = average(stats.DownDeltas)

		stats.LastUpBytes = transmitted.Up
		stats.LastDownBytes = transmitted.Down

		delta := stats.AvgDown + stats.AvgUp
		if delta > maxDelta {
			maxDelta = delta
			sc.Current = *stats
		}
	}
}

func main() {
	calculator := NewSpeedCalculator()
	ticker := time.NewTicker(time.Second / 4)
	defer ticker.Stop()

	encoder := json.NewEncoder(os.Stdout)

	for range ticker.C {
		currentStats, err := calculator.parseNetDev()
		if err != nil {
			log.Fatalf("Error reading net dev: %v", err)
		}

		calculator.updateDeltas(currentStats)
		encoder.Encode(calculator.Current)
	}
}
