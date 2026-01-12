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
        right: 260
        top: 10
    }

    implicitWidth: body.width
    implicitHeight: body.height

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
        implicitHeight: content.height + (Appearance.space.big * 2)
        implicitWidth: content.width + (Appearance.space.big * 2)
        radius: Appearance.round.larger
        color: Appearance.material.mySurface

        RowLayout {
            id: content
            x: Appearance.space.big
            y: Appearance.space.big
            spacing: Appearance.space.small
            ColumnLayout {
                Item {
                    width: downProgress.width
                    height: downText.height
                    StyledText {
                        id: downText
                        width: parent.width
                        text: "Download"
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
                CircularProgress {
                    id: downProgress
                    implicitSize: 120
                    lineWidth: 6
                    waveHeight: 4
                    startAngle: 180
                    gapAngle: 10
                    colPrimary: Appearance.material.myPrimary
                    colSecondary: Appearance.material.mySurfaceContainerHigh
                    value: SystemUsage.netDown / (1024 * 1024 * 100)
                    wavy: value > 0.1
                    Text {
                        anchors.centerIn: parent
                        color: Appearance.material.myPrimary
                        text: SystemUsage.netDownString
                        font.family: Appearance.font.family.main
                        font.pixelSize: Appearance.font.pixelSize.small
                    }
                }
            }
            ColumnLayout {
                Item {
                    width: upProgress.width
                    height: upText.height
                    StyledText {
                        id: upText
                        width: parent.width
                        text: "Upload"
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
                CircularProgress {
                    id: upProgress
                    implicitSize: 120
                    lineWidth: 6
                    waveHeight: 4
                    startAngle: 180
                    gapAngle: 10
                    colPrimary: Appearance.material.myPrimary
                    colSecondary: Appearance.material.mySurfaceContainerHigh
                    value: SystemUsage.netUp / (1024 * 1024 * 100)
                    wavy: value > 0.1
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
}
