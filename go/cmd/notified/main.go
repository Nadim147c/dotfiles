package main

import (
	"fmt"
	"sync"
	"time"

	"github.com/godbus/dbus/v5"
	"github.com/godbus/dbus/v5/introspect"
	"github.com/godbus/dbus/v5/prop"
)

type Notification struct {
	Summary string
	Body    string
	Icon    string
}

var (
	notifications []Notification
	mu            sync.Mutex
)

func addNotification(notif Notification) {
	mu.Lock()
	defer mu.Unlock()

	// Add new notification at the beginning
	notifications = append([]Notification{notif}, notifications...)
	printState()

	// Schedule removal after 10 seconds
	time.AfterFunc(10*time.Second, func() {
		removeNotification(notif)
	})
}

func removeNotification(notif Notification) {
	mu.Lock()
	defer mu.Unlock()

	for i, n := range notifications {
		if n == notif {
			notifications = append(notifications[:i], notifications[i+1:]...)
			printState()
			return
		}
	}
}

func printState() {
	mu.Lock()
	defer mu.Unlock()

	str := ""
	for _, item := range notifications {
		str += fmt.Sprintf(
			`(button :class 'notif' (box :orientation 'horizontal' :space-evenly false `+
				`(image :image-width 80 :image-height 80 :path '%s') `+
				`(box :orientation 'vertical' `+
				`(label :width 100 :wrap true :text '%s') `+
				`(label :width 100 :wrap true :text '%s') `+
				`))) `,
			item.Icon, item.Summary, item.Body)
	}

	fmt.Printf("(box :orientation 'vertical' %s)\n", str)
}

const (
	dbusName = "org.freedesktop.Notifications"
	dbusPath = "/org/freedesktop/Notifications"
	dbusIFC  = "org.freedesktop.Notifications"
)

type server struct{}

func (s server) Notify(appName string, replacesID uint32, appIcon string, summary string, body string, actions []string, hints map[string]dbus.Variant, timeout int32) (uint32, *dbus.Error) {
	addNotification(Notification{
		Summary: summary,
		Body:    body,
		Icon:    appIcon,
	})
	return 0, nil
}

func (s server) GetServerInformation() (string, string, string, string, *dbus.Error) {
	return "Custom Notification Server", "ExampleNS", "1.0", "1.2", nil
}

func main() {
	conn, err := dbus.SessionBus()
	if err != nil {
		panic(err)
	}
	defer conn.Close()

	// Request bus name
	reply, err := conn.RequestName(dbusName, dbus.NameFlagDoNotQueue)
	if err != nil || reply != dbus.RequestNameReplyPrimaryOwner {
		panic("Name already taken")
	}

	s := &server{}
	err = conn.Export(s, dbusPath, dbusIFC)
	if err != nil {
		panic(err)
	}

	// Export introspection
	node := &introspect.Node{
		Name: dbusPath,
		Interfaces: []introspect.Interface{
			introspect.IntrospectData,
			prop.IntrospectData,
			{
				Name:    dbusIFC,
				Methods: introspect.Methods(s),
			},
		},
	}
	err = conn.Export(introspect.NewIntrospectable(node), dbusPath, "org.freedesktop.DBus.Introspectable")
	if err != nil {
		panic(err)
	}

	select {}
}
