package main

import (
	"bufio"
	"dotfiles/pkg/log"
	"encoding/json"
	"fmt"
	"log/slog"
	"net"
	"os"
	"sort"
	"strings"
	"time"

	"github.com/spf13/pflag"
)

var (
	XdgRuntime  = os.Getenv("XDG_RUNTIME_DIR")
	HIS         = os.Getenv("HYPRLAND_INSTANCE_SIGNATURE")
	DataSocket  = fmt.Sprintf("%s/hypr/%s/.socket.sock", XdgRuntime, HIS)
	EventSocket = fmt.Sprintf("%s/hypr/%s/.socket2.sock", XdgRuntime, HIS)

	GetActiveWorkspace = []byte("j/activeworkspace")
	GetWorkspaces      = []byte("j/workspaces")
)

// RawWorkspace represents the workspace data from Hyprland
type RawWorkspace struct {
	ID    int    `json:"id"`
	Name  string `json:"name"`
	Title string `json:"lastwindowtitle"`
}

// Workspace represents the formatted workspace data for output
type Workspace struct {
	ID     int    `json:"id"`
	Name   string `json:"name"`
	Title  string `json:"hover"`
	Active bool   `json:"active"`
}

type ActiveWorkspace struct {
	ID int `json:"id"`
}

var (
	Quiet = false
	OSD   = false
)

func init() {
	pflag.BoolVarP(&Quiet, "quiet", "q", Quiet, "Suppress all logs")
	pflag.BoolVarP(&OSD, "osd", "o", OSD, "Show on screen display")

	pflag.Parse()

	if Quiet {
		log.Setup(slog.LevelError + 1)
	} else {
		log.Setup(slog.LevelDebug)
	}
}

func main() {
	// Get and print initial workspace state
	activeID, err := GetActiveWorkspaceID()
	if err != nil {
		slog.Error("Failed to get active workspace ID", "error", err)
		os.Exit(1)
	}

	if err := PrintWorkspaces(activeID, false); err != nil {
		slog.Error("Failed to print workspaces", "error", err)
		os.Exit(1)
	}

	conn, err := net.Dial("unix", EventSocket)
	if err != nil {
		slog.Error("Failed to connect to event socket", "socket", EventSocket, "error", err)
		panic(err)
	}
	defer conn.Close()

	var id int
	// Listen for events
	scanner := bufio.NewScanner(conn)
	for scanner.Scan() {
		line := scanner.Text()
		split := strings.SplitN(line, ">>", 2)

		if len(split) != 2 {
			slog.Debug("Received malformed event", "line", line)
			continue
		}
		event, meta := split[0], split[1]

		switch event {
		case "openwindow", "openlayer":
			if err := PrintWorkspaces(id, false); err != nil {
				slog.Error("Failed to print workspaces after window event", "event", event, "error", err)
			}
		case "workspacev2":
			var ws int
			_, err := fmt.Sscanf(meta, "%d,", &ws)
			if err != nil {
				slog.Error("Failed to parse workspace ID", "meta", meta, "error", err)
				continue
			}
			id = ws

			if err := PrintWorkspaces(id, true); err != nil {
				slog.Error("Failed to print workspaces after workspace change", "workspace", id, "error", err)
			}
		}
	}

	if err := scanner.Err(); err != nil {
		slog.Error("Scanner error", "error", err)
		panic(err)
	}
}

// GetActiveWorkspaceID gets the currently active workspace ID
func GetActiveWorkspaceID() (int, error) {
	conn, err := net.Dial("unix", DataSocket)
	if err != nil {
		slog.Error("Failed to connect to data socket", "socket", DataSocket, "error", err)
		return 0, err
	}
	defer conn.Close()

	_, err = conn.Write(GetActiveWorkspace)
	if err != nil {
		slog.Error("Failed to write to data socket", "error", err)
		return 0, err
	}

	var result ActiveWorkspace
	if err := json.NewDecoder(conn).Decode(&result); err != nil {
		slog.Error("Failed to decode active workspace", "error", err)
		return 0, err
	}

	return result.ID, nil
}

// PrintWorkspaces outputs the workspaces as JSON
func PrintWorkspaces(id int, switched bool) error {
	// Go code is too fast... Thus, when changing to workspace, the list of workspace
	// gets printed before destroying of empty workspace. The hyprland ipc does send
	// destroywindow event. But sleep is easier and requies less processing.
	time.Sleep(50 * time.Millisecond)

	conn, err := net.Dial("unix", DataSocket)
	if err != nil {
		slog.Error("Failed to connect to data socket", "socket", DataSocket, "error", err)
		return err
	}
	defer conn.Close()

	_, err = conn.Write(GetWorkspaces)
	if err != nil {
		slog.Error("Failed to write to data socket", "error", err)
		return err
	}

	var raw []RawWorkspace
	if err := json.NewDecoder(conn).Decode(&raw); err != nil {
		slog.Error("Failed to decode workspaces", "error", err)
		return err
	}

	workspaces := make([]Workspace, len(raw))
	for i, r := range raw {
		active := r.ID == id
		if switched && active {
			HandleWorkspace(r.Name)
		}
		workspaces[i] = Workspace{
			ID:     r.ID,
			Name:   r.Name,
			Title:  r.Title,
			Active: active,
		}
	}

	// Sort by ID
	sort.Slice(workspaces, func(i, j int) bool {
		return workspaces[i].ID < workspaces[j].ID
	})

	if err := json.NewEncoder(os.Stdout).Encode(workspaces); err != nil {
		slog.Error("Failed to encode workspaces", "error", err)
		return err
	}

	return nil
}
