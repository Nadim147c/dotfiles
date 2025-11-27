pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Hyprland

Singleton {
    id: root
    property bool player: false
    property bool dock: false
    property bool netspeed: false
    property bool wallpaper: false
    property bool clipboard: false
    property bool logout: false

    GlobalShortcut {
        name: "toggle-clipboard"
        description: "Toggle clipboard widget"
        onPressed: root.clipboard = true
    }
}
