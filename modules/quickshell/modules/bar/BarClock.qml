import qs.modules.common

import QtQuick
import QtQuick.Layouts
import Quickshell

Rectangle {
    id: root

    implicitWidth: clock.width + (Appearance.space.medium * 2)
    implicitHeight: parent.height

    radius: Appearance.round.medium

    color: {
        if (mouseArea.containsMouse) {
            return Appearance.material.myPrimary;
        } else {
            return "transparent";
        }
    }

    property color fg: {
        if (mouseArea.containsMouse) {
            return Appearance.material.myOnPrimary;
        } else {
            return Appearance.material.myPrimary;
        }
    }

    Behavior on color {
        ColorAnimation {
            duration: Appearance.time.quick
        }
    }
    Behavior on fg {
        ColorAnimation {
            duration: Appearance.time.quick
        }
    }

    SystemClock {
        id: clockData
        precision: SystemClock.Seconds
    }

    RowLayout {
        id: clock
        y: (parent.height - clock.implicitHeight) / 2
        x: Appearance.space.medium
        spacing: Appearance.space.little
        Text {
            text: Qt.formatDateTime(clockData.date, "hh:mm AP")
            color: root.fg
            font {
                family: Appearance.font.family.main
                pixelSize: Appearance.font.pixelSize.small
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            console.log("Calendar toggle signal emitted");
        }
    }
}
