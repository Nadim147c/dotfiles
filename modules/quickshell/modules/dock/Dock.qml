import qs.modules.common

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

PanelWindow {
    id: root
    anchors.bottom: true
    margins.bottom: Appearance.space.little

    implicitWidth: body.width
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

    Rectangle {
        id: body
        anchors.bottom: parent.bottom
        implicitHeight: opend ? content.height + (Appearance.space.small * 2) : 0
        implicitWidth: content.width + (Appearance.space.small * 2)
        property bool opend: false
        Behavior on implicitHeight {
            animation: Appearance.animation.elementMoveEnter.numberAnimation.createObject(this)
        }
        Component.onCompleted: {
            opend = true;
        }
        radius: Appearance.round.large
        color: Appearance.material.mySurface

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
                icon: "power_settings_new"
                onClicked: Hyprland.dispatch("exec systemctl poweroff")
            }
        }
    }
}
