import qs.modules.common

import QtQuick
import QtQuick.Layouts
import Quickshell

Rectangle {
    id: root

    implicitWidth: clock.width + Appearance.space.little * 2
    implicitHeight: parent.height
    color: {
        if (mouseArea.containsMouse) {
            return Appearance.material.myPrimary;
        } else {
            return "transparent";
        }
    }

    radius: Appearance.round.big

    SystemClock {
        id: clockData
        precision: SystemClock.Seconds
    }

    RowLayout {
        id: clock
        y: (parent.height - clock.implicitHeight) / 2
        x: Appearance.space.little
        spacing: Appearance.space.little
        Text {
            text: Qt.formatDateTime(clockData.date, "hh:mm AP")
            color: {
                if (mouseArea.containsMouse) {
                    return Appearance.material.myOnPrimary;
                } else {
                    return Appearance.material.myPrimary;
                }
            }
            font {
                family: Appearance.font.bold
                pixelSize: 15
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
