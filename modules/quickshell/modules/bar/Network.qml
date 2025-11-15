import qs.modules.common

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire

Rectangle {
    id: root

    implicitWidth: volume.width + (Appearance.space.medium * 2)
    implicitHeight: parent.height

    readonly property real high: 1024 * 1024 * 10 // 10MB/s
    readonly property real medium: 1024 * 1023    //  1MB/s
    readonly property real low: 1024              //  1kB/s

    Behavior on color {
        ColorAnimation {
            duration: Appearance.time.quick
        }
    }

    color: {
        if (mouseArea.containsMouse) {
            return Appearance.material.myPrimary;
        } else if (SystemUsage.netTotal > root.high) {
            return Appearance.material.myPrimaryContainer;
        } else if (SystemUsage.netTotal > root.medium) {
            return Appearance.material.mySurfaceContainerHighest;
        } else {
            return "transparent";
        }
    }
    property color fg: {
        if (mouseArea.containsMouse) {
            return Appearance.material.myOnPrimary;
        } else if (SystemUsage.netTotal > root.high) {
            return Appearance.material.myOnPrimaryContainer;
        } else if (SystemUsage.netTotal > medium) {
            return Appearance.material.myPrimaryContainer;
        } else if (SystemUsage.netTotal > low) {
            return Appearance.material.myPrimary;
        } else {
            return Appearance.material.myOutline;
        }
    }

    radius: Appearance.round.big

    RowLayout {
        id: volume
        y: (parent.height - volume.implicitHeight) / 2
        x: Appearance.space.medium

        spacing: Appearance.space.tiny
        Text {
            text: SystemUsage.netUp > SystemUsage.netDown ? "" : ""
            color: root.fg
            font {
                family: Appearance.font.icon
                bold: true
                pixelSize: 14
            }
            Behavior on color {
                ColorAnimation {
                    duration: 200
                }
            }
        }
        Text {
            text: SystemUsage.netTotalString
            color: root.fg
            font {
                family: Appearance.font.main
                bold: true
                pixelSize: 14
            }
            Behavior on color {
                ColorAnimation {
                    duration: 200
                }
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
    }
}
