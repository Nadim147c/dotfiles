package main

import (
	"cmp"
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
	cpuLastTotal int = 0
	cpuLastIdle  int = 0
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
			after, found := strings.CutPrefix(line, "cpu ")
			if !found {
				continue
			}

			fields := strings.Fields(after)
			ints := mapSlice(fields, func(s string) int { return should(strconv.Atoi(s)) })
			total := reduceSlice(ints, func(a, b int) int { return a + b })
			idle := ints[3] + ints[4]

			idleDelta := float64(idle - cpuLastIdle)
			totalDelta := float64(total - cpuLastTotal)

			state.Utilization = (100 - (idleDelta/totalDelta)*100)

			cpuLastIdle = idle
			cpuLastTotal = total
			break
		}
	}

	return state
}
