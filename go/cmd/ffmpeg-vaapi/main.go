package main

import (
	"dotfiles/pkg/log"
	"fmt"
	"log/slog"
	"os"
	"os/exec"

	"github.com/carapace-sh/carapace"
	"github.com/spf13/cobra"
)

var (
	quiet      bool
	toggle     bool
	audioCodec string
	videoCodec string
	input      string
	output     string
)

func init() {
	cmd.Flags().BoolVarP(&quiet, "quiet", "q", false, "Suppress all logs")
	cmd.Flags().BoolVarP(&toggle, "toggle", "t", false, "Toggle microphone mute state")
	cmd.Flags().StringVarP(&audioCodec, "audio-codec", "a", "aac", "Audio codec (e.g. aac, copy)")
	cmd.Flags().StringVarP(&videoCodec, "video-codec", "v", "h264_vaapi", "Video codec (e.g. h264_vaapi, hevc_vaapi)")
}

var cmd = &cobra.Command{
	Use:   "ffmpeg-vaapi",
	Short: "Run ffmpeg with VAAPI hardware acceleration",
	Args:  cobra.ExactArgs(2),
	PreRun: func(cmd *cobra.Command, args []string) {
		if quiet {
			log.Setup(slog.LevelError + 100)
		} else {
			log.Setup(slog.LevelDebug)
		}
	},
	Run: func(cmd *cobra.Command, args []string) {
		if len(args) < 2 {
			slog.Error("Both input and output files are required")
			os.Exit(1)
		}
		input = args[0]
		output = args[1]

		if !vaapiAvailable() {
			slog.Error("VAAPI not available: /dev/dri/renderD128 not found")
			os.Exit(1)
		}

		// Basic VAAPI validation
		if err := validateVAAPI(); err != nil {
			slog.Error("VAAPI validation failed", "error", err)
			os.Exit(1)
		}

		ffmpegArgs := []string{
			"-loglevel", "warning",
			"-stats",
			"-hwaccel", "vaapi",
			"-hwaccel_device", "/dev/dri/renderD128",
			"-hwaccel_output_format", "vaapi",
			"-i", input,
		}

		// Video processing
		if videoCodec != "copy" {
			ffmpegArgs = append(ffmpegArgs,
				"-vf", "format=nv12|p010le|yuv420p,hwupload",
				"-c:v", videoCodec,
			)
		} else {
			ffmpegArgs = append(ffmpegArgs, "-c:v", "copy")
		}

		// Audio processing
		ffmpegArgs = append(ffmpegArgs, "-c:a", audioCodec)
		ffmpegArgs = append(ffmpegArgs, output)

		ffmpegCmd := exec.Command("ffmpeg", ffmpegArgs...)
		ffmpegCmd.Stdout = os.Stdout
		ffmpegCmd.Stderr = os.Stderr

		slog.Debug("Executing command", "command", ffmpegCmd.String())
		if err := ffmpegCmd.Run(); err != nil {
			slog.Error("ffmpeg failed", "error", err)
			os.Exit(1)
		}
	},
}

func vaapiAvailable() bool {
	_, err := os.Stat("/dev/dri/renderD128")
	return err == nil
}

func validateVAAPI() error {
	// Check VAAPI drivers are properly installed
	if _, err := exec.LookPath("vainfo"); err == nil {
		cmd := exec.Command("vainfo")
		output, err := cmd.CombinedOutput()
		if err != nil {
			return fmt.Errorf("vainfo failed: %v\n%s", err, output)
		}
		slog.Debug("VAAPI validation succeeded")
	}
	return nil
}

func main() {
	comp := carapace.Gen(cmd)
	comp.Standalone()
	comp.FlagCompletion(carapace.ActionMap{
		"audio-codec": carapace.ActionValues(
			"aac", "ac3", "alac", "copy", "flac", "libmp3lame", "libopus", "libvorbis", "mp2",
			"mp3", "opus", "pcm_s16le", "pcm_s24le", "pcm_s32le", "vorbis", "wmav2",
		),
		"video-codec": carapace.ActionValues(
			"h264_vaapi", "hevc_vaapi", "vp8_vaapi", "vp9_vaapi", "av1_vaapi", "mpeg2_vaapi",
			"mjpeg_vaapi", "h264", "hevc", "vp8", "vp9", "av1", "mpeg2", "mjpeg", "copy",
		),
	})
	comp.PositionalAnyCompletion(carapace.ActionFiles())

	if err := cmd.Execute(); err != nil {
		slog.Error("Command execution failed", "error", err)
		os.Exit(1)
	}
}
