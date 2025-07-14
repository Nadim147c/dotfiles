package main

import (
	"dotfiles/pkg/log"
	"encoding/json"
	"log/slog"
	"os"
	"os/exec"

	"github.com/spf13/pflag"
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

func init() {
	quiet := pflag.BoolP("quiet", "q", false, "Suppress all logs")
	pflag.Parse()

	if *quiet {
		log.Setup(slog.LevelError + 1)
	} else {
		log.Setup(slog.LevelDebug)
	}
}

func main() {
	// Get all sound microphones
	microphones, err := ListSources()
	if err != nil {
		slog.Error("Error getting microphones", "error", err)
		os.Exit(1)
	}

	// Find first running microphone or fallback to default
	microphone, err := SelectMicrophone(microphones)
	if err != nil {
		slog.Error("No suitable microphone found", "error", err)
		os.Exit(1)
	}

	// Prepare and output result
	output := GetOutput(microphone)
	json.NewEncoder(os.Stdout).Encode(output)
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
