import qs.modules.common

import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    implicitWidth: volume.width + (Appearance.space.medium * 2)
    implicitHeight: parent.height

    readonly property real high: 80
    readonly property real medium: 60
    readonly property real low: 5

    Behavior on color {
        ColorAnimation {
            duration: Appearance.time.quick
        }
    }

    color: {
        if (mouseArea.containsMouse) {
            return Appearance.material.myPrimary;
        } else if (SystemUsage.cpuUtilization > root.high) {
            return Appearance.material.myError;
        } else if (SystemUsage.cpuUtilization > root.medium) {
            return Appearance.material.mySurfaceContainerHighest;
        } else {
            return "transparent";
        }
    }
    property color fg: {
        if (mouseArea.containsMouse) {
            return Appearance.material.myOnPrimary;
        } else if (SystemUsage.cpuUtilization > root.high) {
            return Appearance.material.myOnError;
        } else if (SystemUsage.cpuUtilization > medium) {
            return Appearance.material.myPrimaryContainer;
        } else if (SystemUsage.cpuUtilization > low) {
            return Appearance.material.myPrimary;
        } else {
            return Appearance.material.myOutline;
        }
    }

    radius: Appearance.round.large

    RowLayout {
        id: volume
        y: (parent.height - volume.implicitHeight) / 2
        x: Appearance.space.medium

        spacing: Appearance.space.tiny
        Text {
            text: "memory"
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
            text: SystemUsage.cpuUtilization.toFixed(2) + "%"
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
    }
}
