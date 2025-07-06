package main

import (
	"bufio"
	"dotfiles/pkg/diskspace"
	"os"
	"strconv"
	"strings"
)

type NetStat struct {
	// Interface is the name of network interface
	Interface string
	// Rx is the download speed and Tx is the upload speed in byte
	Rx, Tx diskspace.Diskspace
}

func ParseNetDev() (map[string]NetStat, error) {
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
		stats[iface] = NetStat{Interface: iface, Rx: diskspace.Diskspace(rx), Tx: diskspace.Diskspace(tx)}
	}

	return stats, nil
}
