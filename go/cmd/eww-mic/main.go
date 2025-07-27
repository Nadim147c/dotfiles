package main

import (
	"dotfiles/pkg/log"
	"encoding/json"
	"log/slog"
	"os"
	"os/exec"

	"github.com/carapace-sh/carapace"
	"github.com/spf13/cobra"
)

type Microphone struct {
	Name        string     `json:"name"`
	State       string     `json:"state"`
	Mute        bool       `json:"mute"`
	Description string     `json:"description"`
	Properties  Properties `json:"properties"`
}

type Properties struct {
	Class string `json:"device.class"`
}

type DefaultSourceInfo struct {
	DefaultSourceName string `json:"default_source_name"`
}

type Output struct {
	Class       string `json:"class"`
	Display     bool   `json:"display"`
	Name        string `json:"name"`
	Description string `json:"description"`
}

var (
	quiet  bool
	toggle bool
)

func init() {
	cmd.Flags().BoolVarP(&quiet, "quiet", "q", false, "Suppress all logs")
	cmd.Flags().BoolVarP(&toggle, "toggle", "t", false, "Toggle microphone mute state")
}

var cmd = &cobra.Command{
	Use:   "eww-mic",
	Short: "Manage microphone state and output information",
	PreRun: func(cmd *cobra.Command, args []string) {
		if quiet {
			log.Setup(slog.LevelError + 1)
		} else {
			log.Setup(slog.LevelDebug)
		}
	},
	Run: func(cmd *cobra.Command, args []string) {
		microphone, err := GetMicrophone()
		if err != nil {
			slog.Error("No suitable microphone found", "error", err)
			os.Exit(1)
		}

		if toggle {
			cmd := exec.Command("pactl", "set-source-mute", microphone.Name, "toggle")
			err := cmd.Run()
			if err != nil {
				slog.Error("Failed to toggle microphone state", "error", err)
				os.Exit(1)
			}

			microphone, err := GetMicrophone()
			if err != nil {
				slog.Error("No suitable microphone found", "error", err)
				os.Exit(1)
			}
			output := GetOutput(microphone)
			b, err := json.Marshal(output)
			if err != nil {
				slog.Error("Failed encode json", "error", err)
				os.Exit(1)
			}

			ewwCmd := exec.Command("eww", "update", "microphone="+string(b))
			if err := ewwCmd.Run(); err != nil {
				slog.Error("Failed to update eww variable", "error", err)
				os.Exit(1)
			}

			return
		}

		// Prepare and output result
		output := GetOutput(microphone)
		json.NewEncoder(os.Stdout).Encode(output)
	},
}

func GetMicrophone() (*Microphone, error) {
	// Get all sound microphones
	microphones, err := ListSources()
	if err != nil {
		return nil, err
	}

	// Find first running microphone or fallback to default
	return SelectMicrophone(microphones)
}

func ListSources() ([]Microphone, error) {
	cmd := exec.Command("pactl", "--format", "json", "list", "sources")
	output, err := cmd.Output()
	if err != nil {
		return nil, err
	}

	var allSources []Microphone
	if err := json.Unmarshal(output, &allSources); err != nil {
		return nil, err
	}

	// Filter sound devices
	var soundMics []Microphone
	for _, mic := range allSources {
		if mic.Properties.Class == "sound" {
			soundMics = append(soundMics, mic)
		}
	}

	return soundMics, nil
}

func SelectMicrophone(mics []Microphone) (*Microphone, error) {
	// First try to find a running microphone
	for _, mic := range mics {
		if mic.State == "RUNNING" {
			return &mic, nil
		}
	}

	// If no running mic found, get default source
	cmd := exec.Command("pactl", "--format", "json", "info", "@DEFAULT_SOURCE@")
	output, err := cmd.Output()
	if err != nil {
		return nil, err
	}

	var info DefaultSourceInfo
	if err := json.Unmarshal(output, &info); err != nil {
		return nil, err
	}

	// Find microphone matching default source name
	for _, mic := range mics {
		if mic.Name == info.DefaultSourceName {
			return &mic, nil
		}
	}

	// Fallback to first available microphone
	if len(mics) > 0 {
		return &mics[0], nil
	}

	return nil, os.ErrNotExist
}

func GetOutput(mic *Microphone) Output {
	recording := mic.State == "RUNNING" && !mic.Mute
	muted := mic.Mute

	class := "muted"
	if recording {
		class = "recording"
	}

	return Output{
		Class:       class,
		Display:     recording || muted,
		Name:        mic.Name,
		Description: mic.Description,
	}
}

func main() {
	carapace.Gen(cmd).Standalone()
	if err := cmd.Execute(); err != nil {
		slog.Error("Command execution failed", "error", err)
		os.Exit(1)
	}
}
