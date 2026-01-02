package main

import (
	"bufio"
	"os"
	"strings"

	"github.com/Nadim147c/real-go/data"
)

type MemState struct {
	Total     data.Size
	Free      data.Size
	Available data.Size
	SwapTotal data.Size
	SwapFree  data.Size
}

func should[T any](v T, _ error) T {
	return v
}

func GetMemState() MemState {
	var mem MemState

	file, err := os.Open("/proc/meminfo")
	if err != nil {
		return mem
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)

	var found int
	for scanner.Scan() {
		prefix, size, ok := strings.Cut(scanner.Text(), ":")
		if !ok {
			return mem
		}
		switch prefix {
		case "MemTotal":
			found++
			mem.Total = should(data.ParseSize(size))
		case "MemFree":
			found++
			mem.Free = should(data.ParseSize(size))
		case "MemAvailable":
			found++
			mem.Available = should(data.ParseSize(size))
		case "SwapTotal":
			found++
			mem.SwapTotal = should(data.ParseSize(size))
		case "SwapFree":
			found++
			mem.SwapFree = should(data.ParseSize(size))
		default:
		}
		if found == 5 {
			break
		}
	}

	return mem
}
