import qs.modules.common

import QtQuick
import QtQuick.Shapes
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

PanelWindow {
    id: root
    anchors.bottom: true

    implicitWidth: body.width + (borderRadius * 2)
    implicitHeight: 200

    aboveWindows: true
    exclusionMode: ExclusionMode.Ignore

    color: "transparent"

    HyprlandFocusGrab {
        windows: [root]
        active: Toggle.dock
        onCleared: Toggle.dock = false
    }

    MouseArea {
        anchors.top: parent.top
        implicitWidth: parent.width
        implicitHeight: parent.height - body.height
        onClicked: Toggle.dock = false
    }

    property real borderRadius: Appearance.round.large
    property color bg: Appearance.material.mySurface

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
        anchors.bottom: parent.bottom
        x: root.borderRadius
        implicitHeight: content.height + (Appearance.space.small * 2)
        implicitWidth: content.width + (Appearance.space.small * 2)
        radius: root.borderRadius
        color: root.bg

        RowLayout {
            id: content
            x: Appearance.space.small
            y: Appearance.space.small
            spacing: Appearance.space.small

            DockButton {
                icon: "qr_code"
                onClicked: Hyprland.dispatch("exec hyprqr-decode")
            }

            DockButton {
                icon: "screenshot_region"
                onClicked: Hyprland.dispatch("exec screenshot")
            }

            DockButton {
                icon: "screenshot_frame"
                onClicked: Hyprland.dispatch("exec screenshot active-output")
            }

            DockButton {
                icon: "document_scanner"
                onClicked: Hyprland.dispatch("exec hyprocr.sh")
            }

            DockButton {
                icon: "wallpaper"
                onClicked: Toggle.wallpaper = true
            }

            // Temporally
            DockButton {
                icon: "power_settings_new"
                onClicked: Hyprland.dispatch("exec systemctl poweroff")
            }
        }
    }
}
