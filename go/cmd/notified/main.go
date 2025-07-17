package main

import (
	"dotfiles/pkg/log"
	"encoding/json"
	"fmt"
	"log/slog"
	"math/rand"
	"net"
	"os"
	"path/filepath"
	"sync"
	"time"

	"github.com/godbus/dbus/v5"
	"github.com/spf13/pflag"
)

type Notification struct {
	ID         uint32    `json:"id"`
	AppName    string    `json:"app_name"`
	ReplacesID uint32    `json:"replaces_id"`
	AppIcon    string    `json:"app_icon"`
	Summary    string    `json:"summary"`
	Body       string    `json:"body"`
	Actions    []Action  `json:"actions"`
	Hints      Hints     `json:"hints"`
	Expires    time.Time `json:"expiry"`
	Time       time.Time `json:"timestamp"`
}

type Action struct {
	ID    string `json:"id"`
	Label string `json:"label"`
}

type BroadCastMessage struct {
	Active  []*Notification `json:"active"`
	History []*Notification `json:"history"`
}

type Server struct {
	mu   sync.Mutex
	dbus *dbus.Conn

	command net.Listener

	listener net.Listener
	clients  map[int64]net.Conn

	counter uint32
	active  *NotificationList
	history *NotificationList
}

const (
	Path            = "/org/freedesktop/Notifications"
	BaseInterface   = "org.freedesktop.Notifications"
	ActionInterface = "org.freedesktop.Notifications.ActionInvoked"
	CloseInterface  = "org.freedesktop.Notifications.NotificationClosed"
)

var (
	ListenSocket  = filepath.Join(os.Getenv("XDG_RUNTIME_DIR"), "notified", "listen.sock")
	CommandSocket = filepath.Join(os.Getenv("XDG_RUNTIME_DIR"), "notified", "command.sock")
)

var (
	FlagQuiet     = false
	FlagSubscribe = false
)

func init() {
	pflag.BoolVarP(&FlagQuiet, "quiet", "q", FlagQuiet, "Suppress all logs")
	pflag.BoolVarP(&FlagSubscribe, "eww", "e", FlagSubscribe, "Subscribe to eww daemon")

	pflag.Parse()

	if FlagQuiet {
		log.Setup(slog.LevelError + 1)
	} else {
		log.Setup(slog.LevelDebug)
	}
}

func main() {
	if len(pflag.Args()) != 0 {
		err := HandleCommand(pflag.Args())
		if err != nil {
			slog.Error("Failed to handle command", "error", err)
		}
		os.Exit(0)
	}

	if FlagSubscribe {
		Subscribe()
		os.Exit(1)
	}
	defer os.RemoveAll(ImageCacheDir)

	dbusConn, err := dbus.ConnectSessionBus()
	if err != nil {
		slog.Error("Failed to connect to session bus", "error", err)
		os.Exit(1)
	}
	defer dbusConn.Close()

	reply, err := dbusConn.RequestName(BaseInterface, dbus.NameFlagDoNotQueue)
	if err != nil {
		slog.Error("Failed to request name", "error", err)
		os.Exit(1)
	}
	if reply != dbus.RequestNameReplyPrimaryOwner {
		slog.Error("Another notification daemon is already running")
		os.Exit(1)
	}

	counter := uint32(rand.Int31()) & 0xFFFF0000

	EnsureDirectoryMust(filepath.Dir(ListenSocket))
	os.Remove(ListenSocket)

	listener, err := net.Listen("unix", ListenSocket)
	if err != nil {
		slog.Error("Failed to create ListentSocket", "error", err)
		os.Exit(1)
	}
	defer listener.Close()

	slog.Info("Listening on socket", "socket", ListenSocket)

	server := &Server{
		dbus:     dbusConn,
		counter:  counter,
		listener: listener,
		active:   NewNotificationList(nil),
		history:  NewNotificationList(CleanCache),
	}
	dbusConn.Export(server, Path, BaseInterface)

	server.StartCommandListener()
	defer server.command.Close()

	go server.ManageClients()

	slog.Info("Notified is now running as the notification daemon")
	ticker := time.NewTicker(50 * time.Millisecond)
	defer ticker.Stop()
	for range ticker.C {
		server.Clean()
	}
}

func EnsureDirectoryMust(path string) {
	if err := os.MkdirAll(path, 0755); err != nil {
		slog.Error("Failed to create directory", "path", path, "error", err)
		panic(err)
	}
}

func CleanCache(n *Notification) {
	cacheDir := filepath.Join(ImageCacheDir, fmt.Sprint(n.ID))
	err := os.RemoveAll(cacheDir)
	if err != nil {
		slog.Error("Failed to clean cache directory", "path", cacheDir, "error", err)
	}
}

func (n *Server) ManageClients() {
	n.mu.Lock()
	n.clients = make(map[int64]net.Conn)
	n.mu.Unlock()

	for {
		conn, err := n.listener.Accept()
		if err != nil {
			slog.Error("Accept error", "error", err)
			continue
		}
		id := time.Now().UnixNano()
		n.mu.Lock()
		n.clients[id] = conn
		n.mu.Unlock()
	}
}

func (n *Server) GenID() uint32 {
	n.mu.Lock()
	defer n.mu.Unlock()
	n.counter++
	return n.counter
}

func (n *Server) Notify(appName string, replacesId uint32, appIcon string, summary string,
	body string, actions []string, hints map[string]dbus.Variant, expireTimeout int32,
) (uint32, *dbus.Error) {
	id := n.GenID()
	hintStruct := ParseHints(id, hints)

	now := time.Now()
	expires := now.Add(10 * time.Second)
	if expireTimeout > 0 {
		expires = now.Add(time.Duration(expireTimeout) * time.Millisecond)
	}

	actionSturcts := make([]Action, 0, len(actions)/2)
	for i := 0; i+1 <= len(actions); i += 2 {
		action := Action{actions[i], actions[i+1]}
		actionSturcts = append(actionSturcts, action)
	}

	notification := &Notification{
		ID:         id,
		AppName:    appName,
		ReplacesID: replacesId,
		AppIcon:    appIcon,
		Summary:    summary,
		Body:       body,
		Actions:    actionSturcts,
		Hints:      hintStruct,
		Expires:    expires,
		Time:       now,
	}

	if notification.AppName == "Spotify" {
		notification.AppIcon = "spotify"
	}

	n.active.Add(notification)
	n.history.Add(notification)

	n.BroadCast()
	return id, nil
}

func (n *Server) BroadCast() {
	slog.Info("Notification status broadcast has been requested")
	defer slog.Info("Notification has been BroadCasted to all clients")

	active := n.active.Snapshot()
	history := n.history.Snapshot()

	data := map[string][]*Notification{
		"active":  active,
		"history": history,
	}

	b, err := json.Marshal(data)
	if err != nil {
		slog.Error("Failed to encode json", "error", err)
		return
	}
	b = append(b, '\n')

	slog.Debug("BroadCasting notification", "message_size", len(b), "clients", len(n.clients))
	for id, client := range n.clients {
		slog.Debug("Writing to client", "id", id)
		_, err := client.Write(b)
		if err != nil {
			slog.Error("Failed to write to client", "error", err)
			client.Close()
			n.mu.Lock()
			delete(n.clients, id)
			n.mu.Unlock()
		}
	}
}

func (n *Server) Clean() {
	n.mu.Lock()
	defer n.mu.Unlock()

	now := time.Now()
	cleaned, amount := n.active.Filter(func(d *Notification) bool {
		return d.Expires.After(now)
	})

	// TODO: remove this clean
	n.history.Filter(func(d *Notification) bool {
		return d.Expires.Add(10 * time.Minute).After(now)
	})

	if cleaned {
		slog.Debug("Cleaned expired notifications", "amount", amount)
		go n.BroadCast()
	}
}

func (n *Server) SendAction(id uint32, action string) error {
	err := n.dbus.Emit(Path, ActionInterface, id, action)
	if err != nil {
		slog.Error("Failed to emit action", "id", id, "action", action, "error", err)
		return err
	}

	err = n.dbus.Emit(Path, CloseInterface, id, uint32(2))
	if err != nil {
		slog.Error("Failed to emit close notification", "id", id, "error", err)
		return err
	}
	return nil
}

func (n *Server) GetCapabilities() ([]string, *dbus.Error) {
	return []string{"body", "actions", "icon-static"}, nil
}

func (n *Server) GetServerInformation() (string, string, string, string, *dbus.Error) {
	return "GoNotifier", "Ephemeral", "1.0", "1.2", nil
}

func (n *Server) CloseNotification(id uint32) *dbus.Error {
	slog.Debug("CloseNotification called", "id", id)

	h := n.history.Remove(id)
	a := n.active.Remove(id)

	if h || a {
		slog.Debug("Cleaned closed notifications", "id", id, "active", a, "history", h)
		go n.BroadCast()
	}

	return nil
}
