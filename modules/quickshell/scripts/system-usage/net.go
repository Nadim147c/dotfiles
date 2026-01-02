package main

import (
	"bufio"
	"log"
	"os"
	"slices"
	"strconv"
	"strings"

	"github.com/Nadim147c/real-go/data"
)

const NetDev = "/proc/net/dev"

type number interface {
	~int | ~int8 | ~int16 | ~int32 | ~int64 |
		~uint | ~uint8 | ~uint16 | ~uint32 | ~uint64 |
		~uintptr | ~float32 | ~float64
}

func average[T number](s []T) T {
	if len(s) == 0 {
		return 0
	}
	var t T
	for elem := range slices.Values(s) {
		t += elem
	}
	return t / T(len(s))
}

type NetTransmitted struct {
	Up, Down data.Size
}

type NetStats map[string]NetTransmitted

type NetInterfaceStats struct {
	Name       string
	TotalUp    data.Size
	TotalDown  data.Size
	Up         data.Speed
	Down       data.Speed
	Total      data.Speed
	UpDeltas   []data.Size
	DownDeltas []data.Size
}

type NetSpeedCalculator struct {
	Interfaces map[string]*NetInterfaceStats
	Current    *NetInterfaceStats
}

func NewNetSpeedCalculator() *NetSpeedCalculator {
	return &NetSpeedCalculator{
		Interfaces: make(map[string]*NetInterfaceStats),
		Current:    &NetInterfaceStats{},
	}
}

func (sc *NetSpeedCalculator) parseNetDev() (NetStats, error) {
	file, err := os.Open(NetDev)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	currentStats := make(NetStats)
	scanner := bufio.NewScanner(file)

	// Skip the first two header lines
	scanner.Scan()
	scanner.Scan()

	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if line == "" {
			continue
		}

		// Split by colon to separate interface name from data
		ifaceName, stats, found := strings.Cut(line, ":")
		if !found {
			continue
		}

		// Parse the data fields (bytes are the first field after interface name)
		dataFields := strings.Fields(stats)
		if len(dataFields) < 1 {
			continue
		}

		Down, err := strconv.Atoi(dataFields[0])
		if err != nil {
			continue
		}

		Up, err := strconv.Atoi(dataFields[8])
		if err != nil {
			continue
		}
		currentStats[ifaceName] = NetTransmitted{
			Down: data.Size(Down),
			Up:   data.Size(Up),
		}
	}

	return currentStats, nil
}

func (sc *NetSpeedCalculator) updateDeltas(currentStats NetStats) {
	for name := range sc.Interfaces {
		if _, exists := currentStats[name]; !exists {
			delete(sc.Interfaces, name)
		}
	}

	var maxDelta data.Speed
	// Update existing interfaces and add new ones
	for name, transmitted := range currentStats {
		stats, exists := sc.Interfaces[name]
		if !exists {
			sc.Interfaces[name] = &NetInterfaceStats{
				Name:       name,
				TotalUp:    transmitted.Up,
				TotalDown:  transmitted.Down,
				UpDeltas:   make([]data.Size, 4), // Buffer for last
				DownDeltas: make([]data.Size, 4), // Buffer for last
			}
			continue
		}

		dd := max(transmitted.Down-stats.TotalDown, 0)
		du := max(transmitted.Up-stats.TotalUp, 0)

		stats.Down = data.NewSpeed(average(stats.DownDeltas), UpdateTime)
		stats.DownDeltas = append(stats.DownDeltas[1:], dd)
		stats.Up = data.NewSpeed(average(stats.UpDeltas), UpdateTime)
		stats.UpDeltas = append(stats.UpDeltas[1:], du)

		stats.TotalUp = transmitted.Up
		stats.TotalDown = transmitted.Down

		stats.Total = stats.Up + stats.Down

		delta := stats.Down + stats.Up
		if delta > maxDelta {
			maxDelta = delta
			sc.Current = stats
		}
	}
}

func (c *NetSpeedCalculator) Update() NetInterfaceStats {
	currentStats, err := c.parseNetDev()
	if err != nil {
		log.Fatalf("Error reading net dev: %v", err)
	}

	c.updateDeltas(currentStats)
	return *c.Current
}
