#!/usr/bin/env scriptisto

// This program adjusts the screen color temperature throughout the day using Hyprland's `hyprctl hyprsunset`.
//
// Behavior:
// - During the daytime (5:00 AM to 6:00 PM), the temperature is set to **8000K** (cool, blue light).
// - From **6:00 PM to 10:00 PM**, the temperature gradually decreases from **8000K → 5000K**.
// - After **10:00 PM** and until the next day at **5:00 AM**, the temperature remains at **5000K** (warm, red light).
// - At **5:00 AM**, it resets back to **8000K**.
//
// The program runs continuously, checking and updating the temperature every minute.

package main

// scriptisto-begin
// script_src: main.go
// build_once_cmd: go mod tidy
// build_cmd: go build -o hyprsunset-daemon
// target_bin: hyprsunset-daemon
// replace_shebang_with: //
// files:
//  - path: go.mod
//    content: |
//      module hyprsunset
//
//      go 1.24
// scriptisto-end

import (
	"fmt"
	"os/exec"
	"time"
)

// Temperature settings in Kelvin
const (
	DayTemp   int64 = 8000
	NightTemp int64 = 5000
	TempDelta int64 = DayTemp - NightTemp

	DayLength    = 24 * time.Hour
	DayStart     = 5 * time.Hour              // 5:00 AM
	Relative6PM  = 18*time.Hour - DayStart    // 6:00 PM relative to 5 AM
	Relative10PM = 22*time.Hour - DayStart    // 10:00 PM relative to 5 AM
	TimeDelta    = Relative10PM - Relative6PM // Time between 6:00PM to 10:00PM
	TickTime     = 1 * time.Minute            // Interval to update temperature
)

func main() {
	// Create a ticker that triggers every 1 minute
	ticker := time.NewTicker(TickTime)
	defer ticker.Stop()

	for {
		// Get current time
		now := time.Now()

		pastMidnight := time.Duration(
			now.Hour()*int(time.Hour) +
				now.Minute()*int(time.Minute) +
				now.Second()*int(time.Second) +
				now.Nanosecond(),
		)

		// Adjust relative to "start of day" at 5:00 AM
		var relativeTime time.Duration
		if pastMidnight > DayStart {
			relativeTime = pastMidnight - DayStart
		} else {
			relativeTime = DayLength - (DayStart - pastMidnight)
		}

		// Set default temperature
		temp := DayTemp

		if relativeTime >= Relative6PM {
			temp -= (int64(relativeTime-Relative6PM) * TempDelta) / int64(TimeDelta)
		}

		temp = max(temp, NightTemp)

		fmt.Printf("Time: %s | Temperature: %dK\n", now.Format(time.Kitchen), temp)
		SetTemperature(temp)

		<-ticker.C // Wait for the next tick
	}
}

func SetTemperature(temp int64) {
	cmd := exec.Command("hyprctl", "hyprsunset", "temperature", fmt.Sprintf("%d", temp))
	if err := cmd.Run(); err != nil {
		fmt.Printf("Error setting temperature: %v\n", err)
	}
}
