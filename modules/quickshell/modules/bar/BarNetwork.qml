import qs.modules.common

import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    implicitWidth: volume.width + (Appearance.space.medium * 2)
    implicitHeight: parent.height

    readonly property real high: 1024 * 1024 * 10
    readonly property real medium: 1024 * 1023
    readonly property real low: 1024

    Behavior on color {
        ColorAnimation {
            duration: Appearance.time.quick
        }
    }

    color: {
        if (mouseArea.containsMouse) {
            return Appearance.material.myPrimary;
        } else if (SystemUsage.netTotal > root.high) {
            return Appearance.material.mySecondary;
        } else {
            return Appearance.material.mySurfaceVariant;
        }
    }
    property color fg: {
        if (mouseArea.containsMouse) {
            return Appearance.material.myOnPrimary;
        } else if (SystemUsage.netTotal > root.high) {
            return Appearance.material.myOnSecondary;
        } else if (SystemUsage.netTotal > root.medium) {
            return Appearance.material.myOnSurface;
        } else if (SystemUsage.netTotal > root.low) {
            return Appearance.material.myPrimary;
        } else {
            return Appearance.material.myOnSurfaceVariant;
        }
    }

    radius: Appearance.round.large

    RowLayout {
        id: volume
        y: (parent.height - volume.implicitHeight) / 2
        x: Appearance.space.medium

        spacing: Appearance.space.tiny
        Text {
            text: SystemUsage.netUp > SystemUsage.netDown ? "arrow_upward" : "arrow_downward"
            color: root.fg
            font {
                family: Appearance.font.family.iconMaterial
                pixelSize: Appearance.font.pixelSize.small
            }
            Behavior on color {
                ColorAnimation {
                    duration: 200
                }
            }
        }
        Text {
            text: SystemUsage.netTotalString + " "
            color: root.fg
            font {
                family: Appearance.font.family.main
                pixelSize: Appearance.font.pixelSize.small
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
        onClicked: Toggle.netspeed = true
    }
}
