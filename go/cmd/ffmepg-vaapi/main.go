package main

import (
	"dotfiles/pkg/log"
	"fmt"
	"log/slog"
	"os"
	"os/exec"

	"github.com/spf13/pflag"
)

func vaapiAvailable() bool {
	_, err := os.Stat("/dev/dri/renderD128")
	return err == nil
}

var (
	Quiet      = false
	Toggle     = false
	AudioCodec = "aac"
	VideoCodec = "h265_vaapi"
	Input      string
	Output     string
)

func init() {
	pflag.BoolVarP(&Quiet, "quiet", "q", Quiet, "Suppress all logs")
	pflag.BoolVarP(&Toggle, "toggle", "t", Toggle, "Toggle microphone mute state")
	pflag.StringVar(&AudioCodec, "ac", "aac", "Audio codec (e.g. aac, copy)")
	pflag.StringVar(&VideoCodec, "vc", "h264_vaapi", "Video codec (e.g. h264_vaapi, hevc_vaapi)")

	pflag.Parse()
	Input = pflag.Arg(0)
	Output = pflag.Arg(1)

	if Quiet {
		log.Setup(slog.LevelError + 1)
	} else {
		log.Setup(slog.LevelDebug)
	}
}

func main() {
	if !vaapiAvailable() {
		slog.Error("VAAPI not available: /dev/dri/renderD128 not found")
		os.Exit(1)
	}

	cmd := exec.Command("ffmpeg",
		"-hwaccel", "vaapi",
		"-hwaccel_device", "/dev/dri/renderD128",
		"-hwaccel_output_format", "vaapi",
		"-i", Input,
		"-vf", "format=nv12,hwupload",
		"-c:v", VideoCodec,
		"-c:a", AudioCodec,
		Output,
	)

	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	fmt.Println("Running command:", cmd.String())
	err := cmd.Run()
	if err != nil {
		slog.Error("ffmpeg failed", "error", err)
		os.Exit(1)
	}
}
