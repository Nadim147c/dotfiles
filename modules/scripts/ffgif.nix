{
  delib,
  pkgs,
  ...
}:
delib.script rec {
  name = "ffgif";
  package = pkgs.writers.writeGoBin name { } /* go */ ''
    package main

    import (
    	"bytes"
    	"context"
    	"fmt"
    	"log"
    	"os"
    	"os/exec"
    	"os/signal"
    	"path/filepath"
    	"runtime"
    	"strconv"
    	"syscall"
    )

    func main() {
    	if len(os.Args) < 2 {
    		fmt.Fprintln(os.Stderr, "Use: ffgif <path> [out]")
    		os.Exit(1)
    	}

    	ctx, cancel := signal.NotifyContext(context.Background(), syscall.SIGINT, syscall.SIGTERM)
    	defer cancel()

    	input := os.Args[1]

    	// Determine output file
    	var output string
    	if len(os.Args) >= 3 {
    		output = os.Args[2]
    	} else {
    		ext := filepath.Ext(input)
    		base := filepath.Base(input[:len(input)-len(ext)])
    		output = base + ".gif"
    	}

    	fmt.Println("Output file:", output)

        paletteCmd := exec.CommandContext(
    		ctx, "ffmpeg", "-hide_banner",
    		"-i", input,
    		"-vf", "palettegen",
    		"-f", "image2pipe", "-",
    	)
    	paletteCmd.Stderr = os.Stderr

    	// Generate palette
    	palette, err := paletteCmd.Output()
    	if err != nil {
    		log.Fatalf("failed to generate palette: %v", err)
    	}

    	// Run GIF generation with palette piped to stdin
    	cmd := exec.CommandContext(
    		ctx, "ffmpeg", "-hide_banner",
    		"-i", input,
    		"-i", "pipe:0",
    		"-loop", "0",
    		"-threads", strconv.Itoa(runtime.NumCPU()),
    		"-filter_complex", "fps=10[x];[x][1:v]paletteuse",
    		output,
    	)

    	cmd.Stdin = bytes.NewReader(palette)
    	cmd.Stdout = os.Stdout
    	cmd.Stderr = os.Stderr

    	if err := cmd.Run(); err != nil {
    		log.Fatalf("failed to create gif: %v", err)
    	}
    }
  '';
}
