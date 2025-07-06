package main

import (
	"fmt"
	"os"
	"time"

	"github.com/spf13/pflag"
)

var Format = "%.1B"

func init() {
	format := pflag.StringP("format", "f", "B", `Format for speed
"K" for binary byte (KiB/s, MiB/s...)
"k" for binary bit (Kibps, Mibps...)
"B" for si byte (KB/s, MB/s...)
"b" for si bit (Kbps, Mbps...)
`)

	pflag.Parse()

	switch *format {
	case "K":
		Format = "%.1K/s"
	case "k":
		Format = "%.1kps"
	case "B", "":
		Format = "%.1B/s"
	case "b":
		Format = "%.1bps"
	default:
		panic("Invalid speed format")
	}
}

func main() {
	start := time.Now()
	before, err := ParseNetDev()
	if err != nil {
		panic(err)
	}

	before, iface, err := CalcSpeed(before, "", time.Since(start))
	if err != nil {
		fmt.Fprintln(os.Stderr, "Error:", err)
	}

	interval := 750 * time.Millisecond

	ticker := time.NewTicker(interval)
	for {
		<-ticker.C
		before, iface, err = CalcSpeed(before, iface, interval)
		if err != nil {
			fmt.Fprintln(os.Stderr, "Error:", err)
		}
	}
}
