import qs.modules.common
import qs.modules.end4

import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    implicitWidth: clock.width + (Appearance.space.medium * 2)
    implicitHeight: parent.height

    radius: Appearance.round.medium

    color: {
        if (mouseArea.containsMouse) {
            return Appearance.material.mySecondary;
        } else {
            return Appearance.material.mySurfaceVariant;
        }
    }

    property color fg: {
        if (mouseArea.containsMouse) {
            return Appearance.material.myOnSecondary;
        } else {
            return Appearance.material.myPrimaryFixed;
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

    RowLayout {
        id: clock
        y: (parent.height - clock.implicitHeight) / 2
        x: Appearance.space.medium
        spacing: Appearance.space.little
        MaterialSymbol {
            text: "device_thermostat"
            color: root.fg
            fill: 1
        }
        Text {
            text: Weather.data.temp + " "
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

        onWheel: wheel => {
            console.log("God please, change the weather");
        }
    }
}
