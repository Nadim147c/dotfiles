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
    	"flag"
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
    	flag.CommandLine.Usage = func() {
    		fmt.Fprintln(flag.CommandLine.Output(), "Use: ${name} <video-file> [output-file]")
    		flag.CommandLine.PrintDefaults()
    	}
    	flag.Parse()

    	if flag.NArg() < 1 {
    		flag.CommandLine.Usage()
    		os.Exit(0)
    	}

    	ctx, cancel := signal.NotifyContext(context.Background(), syscall.SIGINT, syscall.SIGTERM)
    	defer cancel()

    	input := flag.Arg(0)
    	output := flag.Arg(1)
    	if output == "" {
    		ext := filepath.Ext(input)
    		base := filepath.Base(input[:len(input)-len(ext)])
    		output = base + ".gif"
    	}

    	fmt.Println("Output file:", output)

    	buf := bytes.NewBuffer(nil)

    	paletteCmd := exec.CommandContext(
    		ctx, "ffmpeg", "-hide_banner",
    		"-i", input,
    		"-vf", "palettegen",
    		"-f", "image2pipe", "-",
    	)
    	paletteCmd.Stderr = os.Stderr
    	paletteCmd.Stdout = buf

    	// Generate palette
    	if err := paletteCmd.Run(); err != nil {
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

    	cmd.Stdin = buf
    	cmd.Stdout = os.Stdout
    	cmd.Stderr = os.Stderr

    	if err := cmd.Run(); err != nil {
    		log.Fatalf("failed to create gif: %v", err)
    	}
    }
  '';
}
