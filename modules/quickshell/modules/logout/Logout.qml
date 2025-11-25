import qs.modules.common
import qs.modules.widgets

import QtQuick
import QtQuick.Shapes
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

PanelWindow {
    id: root

    property real borderRadius: Appearance.round.larger
    property color bg: Appearance.material.mySurface

    anchors.bottom: true
    margins.bottom: 0

    implicitWidth: body.width + (borderRadius * 2)
    implicitHeight: body.height

    WlrLayershell.namespace: "quickshell:logout"
    aboveWindows: true
    exclusiveZone: 0
    color: "transparent"

    mask: Region {
        item: body
    }

    HyprlandFocusGrab {
        windows: [root]
        active: Toggle.logout
        onCleared: Toggle.logout = false
    }

    Shape {
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            strokeWidth: 0
            fillColor: root.bg
            startX: 0
            startY: root.height
            PathArc {
                x: root.borderRadius
                y: root.height - root.borderRadius
                radiusX: root.borderRadius
                radiusY: root.borderRadius
                direction: PathArc.Counterclockwise
            }
            PathLine {
                x: root.width - root.borderRadius
                y: root.height - root.borderRadius
            }
            PathArc {
                x: root.width
                y: root.height
                radiusX: root.borderRadius
                radiusY: root.borderRadius
                direction: PathArc.Counterclockwise
            }
        }
    }

    Rectangle {
        id: body
        x: root.borderRadius
        implicitHeight: content.height + (Appearance.space.big * 2)
        implicitWidth: content.width + (Appearance.space.big * 2)
        radius: root.borderRadius
        color: root.bg

        RowLayout {
            id: content
            x: Appearance.space.big
            y: Appearance.space.big

            property real iconSize: 50

            MaterialButton {
                icon: "bedtime"
                size: parent.iconSize
                onClicked: Quickshell.execDetached(["systemctl", "suspend"])
            }

            MaterialButton {
                icon: "lock"
                size: parent.iconSize
                onClicked: Quickshell.execDetached(["loginctl", "lock-session"])
            }

            MaterialButton {
                icon: "logout"
                size: parent.iconSize
                onClicked: Quickshell.execDetached(["hyprshutdown.sh", "logout"])
            }

            MaterialButton {
                icon: "replay"
                size: parent.iconSize
                onClicked: Quickshell.execDetached(["hyprshutdown.sh", "reboot"])
            }

            MaterialButton {
                icon: "power_settings_new"
                size: parent.iconSize
                onClicked: Quickshell.execDetached(["hyprshutdown.sh", "shutdown"])
            }
        }
    }
}
