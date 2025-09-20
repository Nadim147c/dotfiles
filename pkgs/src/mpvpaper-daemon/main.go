package main

import (
	"context"
	"fmt"
	"log"
	"log/slog"
	"net"
	"slices"

	"github.com/thiagokokada/hyprland-go"
	"github.com/thiagokokada/hyprland-go/event"
)

const MpvPaperSocket string = "/tmp/mpv-socket-All"

var (
	workspace      string
	hyprlandClient *hyprland.RequestClient
	mpvpaperClient net.Conn
)

type handler struct {
	event.DefaultEventHandler
}

func (e *handler) Workspace(w event.WorkspaceName) {
	workspace = string(w)
	PlayPause()
}

func (e *handler) ActiveWindow(w event.ActiveWindow) {
	PlayPause()
}

func PlayPause() {
	clients, err := hyprlandClient.Clients()
	if err != nil {
		slog.Error("Failed to get clients", "error", err)
		return
	}

	for window := range slices.Values(clients) {
		if window.Workspace.Name == workspace && !window.Floating {
			fmt.Println("Pausing")
			fmt.Fprintln(mpvpaperClient, "set pause yes")
			return
		}
	}
	fmt.Println("Playing")
	fmt.Fprintln(mpvpaperClient, "set pause no")
}

func main() {
	conn, err := net.Dial("unix", MpvPaperSocket)
	if err != nil {
		log.Fatalf("Failed to connect to mpvpaper socket: %v", err)
	}
	defer conn.Close()

	mpvpaperClient = conn

	hyprlandClient = hyprland.MustClient()

	c := event.MustClient()
	defer c.Close()

	c.Subscribe(context.Background(), &handler{}, event.EventWorkspace, event.EventActiveWindow)

	fmt.Println("Bye!")
}
