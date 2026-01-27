package main

import (
	"cmp"
	"fmt"
	"os"
	"path/filepath"
	"slices"
	"strconv"
	"strings"

	"github.com/Nadim147c/real-go/temperature"
)

func mapSlice[T any, U any](s []T, t func(T) U) []U {
	res := make([]U, len(s))
	for i, v := range s {
		res[i] = t(v)
	}
	return res
}

func reduceSlice[T cmp.Ordered, U cmp.Ordered](s []T, t func(a T, v T) U) U {
	var last T
	var res U
	for _, v := range s {
		res += t(last, v)
	}
	return res
}

type CPUState struct {
	Frequency   uint64                  // in kHz
	Temperature temperature.Temperature // in Kelvin
	Utilization float64                 // percentage
}

func ReadAllFiles(paths []string) []string {
	res := make([]string, 0, len(paths))
	for path := range slices.Values(paths) {
		data, err := os.ReadFile(path)
		if err != nil {
			continue
		}
		res = append(res, strings.TrimSpace(string(data)))
	}
	return res
}

var (
	cpuLastTotal uint64
	cpuLastIdled uint64
)

// GetCPUState retrieves basic CPU state, ignoring errors
func GetCPUState() CPUState {
	var state CPUState

	// 1. Get CPU frequency (first CPU)
	cpuFreqFiles, err := filepath.Glob("/sys/devices/system/cpu/cpu*/cpufreq/scaling_cur_freq")
	if err == nil {
		data := ReadAllFiles(cpuFreqFiles)
		ints := mapSlice(data, func(s string) uint64 {
			return should(strconv.ParseUint(s, 10, 64))
		})
		state.Frequency = average(ints)
	}

	// 2. Get CPU temperature (average of available thermal zones)
	cpuTempFiles, err := filepath.Glob("/sys/class/thermal/thermal_zone*/temp")
	if err == nil {
		data := ReadAllFiles(cpuTempFiles)
		floats := mapSlice(data, func(s string) float64 {
			return should(strconv.ParseFloat(s, 64)) / 1000
		})
		avg := average(floats)
		state.Temperature = temperature.Celsius(avg)
	}

	// 3. Get CPU utilization (approximate since boot)
	if data, err := os.ReadFile("/proc/stat"); err == nil {
		for line := range strings.SplitSeq(string(data), "\n") {
			after := strings.Fields(line)
			if len(after) == 0 || after[0] != "cpu" {
				continue
			}

			var user, nice, system, idle, iowait, irq, softirq, steal, guest, guestNice uint64

			fmt.Sscanf(strings.Join(after[1:], " "), "%d %d %d %d %d %d %d %d %d %d",
				&user, &nice, &system, &idle, &iowait, &irq, &softirq, &steal, &guest, &guestNice)

			total := user + nice + system + idle + iowait + irq + softirq + steal + guest + guestNice
			idleTotal := idle + iowait

			totalDelta := total - cpuLastTotal
			idleDelta := idleTotal - cpuLastIdled

			state.Utilization = (1 - (float64(idleDelta) / float64(totalDelta))) * 100

			cpuLastTotal = total
			cpuLastIdled = idleTotal
			break
		}
	}

	return state
}
