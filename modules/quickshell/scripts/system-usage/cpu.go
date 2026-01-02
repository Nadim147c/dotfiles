package main

import (
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
			if !strings.HasPrefix(line, "cpu ") {
				continue
			}
			fields := strings.Fields(line)
			if len(fields) < 5 {
				break
			}
			// user, nice, system, idle
			user := should(strconv.Atoi(fields[1]))
			nice := should(strconv.Atoi(fields[2]))
			system := should(strconv.Atoi(fields[3]))
			idle := should(strconv.Atoi(fields[4]))
			total := user + nice + system + idle
			if total > 0 {
				state.Utilization = float64(user+nice+system) / float64(total) * 100
			}
			break
		}
	}

	return state
}
