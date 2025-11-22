import qs.modules.common
import qs.modules.end4

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

PanelWindow {
    id: root
    anchors {
        top: true
        right: true
    }

    margins {
        right: 70
    }

    implicitWidth: body.width
    implicitHeight: 150

    WlrLayershell.namespace: "quickshell:player"
    aboveWindows: true
    color: "transparent"

    HyprlandFocusGrab {
        windows: [root]
        active: Toggle.netspeed
        onCleared: Toggle.netspeed = false
    }

    Rectangle {
        id: body
        implicitHeight: content.height + (Appearance.space.small * 2)
        implicitWidth: content.width + (Appearance.space.small * 2)
        radius: Appearance.round.large
        color: Appearance.material.mySurface

        RowLayout {
            id: content
            x: Appearance.space.small
            y: Appearance.space.small
            spacing: Appearance.space.small
            CircularProgress {
                implicitSize: 120
                lineWidth: 4
                startAngle: 180
                gapAngle: 10
                colPrimary: Appearance.material.myPrimary
                colSecondary: Appearance.material.mySurfaceContainerHigh
                value: SystemUsage.netDown / (1024 * 1024 * 50)
                Text {
                    anchors.centerIn: parent
                    color: Appearance.material.myPrimary
                    text: SystemUsage.netDownString
                    font.family: Appearance.font.family.main
                    font.pixelSize: Appearance.font.pixelSize.small
                }
            }
            CircularProgress {
                implicitSize: 120
                lineWidth: 4
                startAngle: 180
                gapAngle: 10
                colPrimary: Appearance.material.myPrimary
                colSecondary: Appearance.material.mySurfaceContainerHigh
                value: SystemUsage.netUp / (1024 * 1024 * 50)
                Text {
                    anchors.centerIn: parent
                    color: Appearance.material.myPrimary
                    text: SystemUsage.netUpString
                    font.family: Appearance.font.family.main
                    font.pixelSize: Appearance.font.pixelSize.small
                }
            }
        }
    }
}
