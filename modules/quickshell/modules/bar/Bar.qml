import qs.modules.common
import qs.modules.end4.functions

import QtQuick
import QtQuick.Shapes
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root
    anchors {
        left: true
        top: true
        right: true
    }
    margins {
        left: 5
        top: 5
        right: 5
    }
    aboveWindows: false

    color: "transparent"
    property color bg: ColorUtils.transparentize(Appearance.material.myBackground, 0.15)

    WlrLayershell.namespace: "quickshell:bar"

    property real borderRadius: Appearance.space.large

    implicitHeight: 32
    exclusiveZone: implicitHeight

    Rectangle {
        id: body
        implicitHeight: 32
        implicitWidth: parent.width
        color: root.bg
        radius: Appearance.space.large

        RowLayout {
            id: rootRow
            anchors {
                fill: parent
                margins: Appearance.space.little
            }

            Rectangle {
                color: "transparent"
                implicitHeight: rootRow.height
                implicitWidth: leftModule.implicitWidth
                RowLayout {
                    id: leftModule
                    anchors.fill: parent
                    spacing: Appearance.space.tiny
                    BarWorkspaces {}
                    BarLyrics {}
                }
            }

            // Spacer to push the next item to the right
            Item {
                Layout.fillWidth: true
            }

            Rectangle {
                color: "transparent"
                implicitHeight: rootRow.height
                implicitWidth: rightModule.implicitWidth
                RowLayout {
                    id: rightModule
                    spacing: Appearance.space.tiny
                    anchors.fill: parent
                    BarCPU {}
                    BarNetwork {}
                    BarVolume {}
                    BarClock {}
                    BarTray {}
                }
            }
        }
    }
}
