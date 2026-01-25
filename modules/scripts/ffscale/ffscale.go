package main

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"log"
	"math"
	"os"
	"os/exec"
	"os/signal"
	"path/filepath"
	"strings"
	"syscall"

	"github.com/spf13/pflag"
)

type FFProbeResult struct {
	Streams []struct {
		Width  int `json:"width"`
		Height int `json:"height"`
	} `json:"streams"`
}

var (
	quality int
	scale   float64
	size    string
	filter  string
)

func main() {
	pflag.Float64VarP(&scale, "scale", "c", 0, "Scale multiplier (e.g. 2, 1.5, 0.5)")
	pflag.IntVarP(&quality, "quality", "q", 0, "Target height (e.g. 1080, 720)")
	pflag.StringVarP(&size, "size", "s", "", "Explicit scale string (e.g. 1920:1080)")
	pflag.StringVarP(&filter, "filter", "f", "", "Addtional ffmpeg filter (e.g. fps=10)")
	pflag.Usage = func() {
		fmt.Fprint(os.Stderr, "USE:\n  ffscale <flags> <input> -- [extra ffmpeg args]\n")
		fmt.Fprint(os.Stderr, "\nFLAGS: \n")
		fmt.Fprint(os.Stderr, pflag.CommandLine.FlagUsages())
	}

	pflag.Parse()

	log.SetFlags(0)

	if pflag.NArg() < 1 {
		log.Fatal("Error: input file required")
	}

	input := pflag.Arg(0)

	width, height, err := runFFProbe(input)
	if err != nil {
		log.Fatal("ffprobe error:", err)
	}

	var scaleStr string

	switch {
	case scale != 0:
		w := roundToEven(float64(width) * scale)
		h := roundToEven(float64(height) * scale)
		scaleStr = fmt.Sprintf("%d:%d", w, h)

	case quality != 0:
		div := float64(height) / float64(quality)
		w := roundToEven(float64(width) / div)
		scaleStr = fmt.Sprintf("%d:%d", w, roundToEven(float64(quality)))

	case size != "":
		scaleStr = size

	default:
		log.Fatal("Error: Either --scale, --quality, or --size must be specified")
	}

	ext := filepath.Ext(input)
	stem := strings.TrimSuffix(input, ext)
	scaleForName := strings.ReplaceAll(scaleStr, ":", "x")
	output := fmt.Sprintf("%s-%s%s", stem, scaleForName, ext)

	ctx, cancel := signal.NotifyContext(context.Background(), syscall.SIGINT, syscall.SIGTERM)
	defer cancel()

	filterGraph := "scale=" + scaleStr
	if filter != "" {
		filterGraph += "," + filter
	}
	cmd := exec.CommandContext(ctx, "ffmpeg", "-hide_banner", "-i", input, "-vf", filterGraph)
	cmd.Args = append(cmd.Args, pflag.Args()[1:]...)
	cmd.Args = append(cmd.Args, output)

	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	fmt.Println("Running:", strings.Join(cmd.Args, " "))

	if err := cmd.Run(); err != nil {
		log.Fatal("ffmpeg error:", err)
	}
}

func roundToEven(f float64) int {
	return int(math.Round(f/2) * 2)
}

func runFFProbe(input string) (int, int, error) {
	cmd := exec.Command("ffprobe",
		"-v", "error",
		"-select_streams", "v:0",
		"-show_entries", "stream=width,height",
		"-of", "json",
		input,
	)

	var out bytes.Buffer
	cmd.Stdout = &out
	cmd.Stderr = os.Stderr

	if err := cmd.Run(); err != nil {
		return 0, 0, err
	}

	var result FFProbeResult
	if err := json.Unmarshal(out.Bytes(), &result); err != nil {
		return 0, 0, err
	}

	if len(result.Streams) == 0 {
		return 0, 0, fmt.Errorf("no video stream found")
	}

	return result.Streams[0].Width, result.Streams[0].Height, nil
}
