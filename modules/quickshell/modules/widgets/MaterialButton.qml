import qs.modules.common
import qs.modules.end4

import QtQuick

Rectangle {
    id: root

    required property string icon
    property real size: 22
    property real containerSize: Math.max(icon.height, icon.width) + (Appearance.space.small * 2)

    signal clicked
    signal rightClicked

    implicitHeight: containerSize
    implicitWidth: containerSize
    radius: Appearance.round.big

    color: mouse.containsMouse ? Appearance.material.myPrimary : Appearance.material.mySurfaceVariant
    property color fg: mouse.containsMouse ? Appearance.material.myOnPrimary : Appearance.material.myOnSurfaceVariant
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

    MouseArea {
        id: mouse
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        hoverEnabled: true
        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton)
                root.clicked();
            else
                root.rightClicked();
        }

        MaterialSymbol {
            id: icon
            x: (root.containerSize - width) / 2
            y: (root.containerSize - height) / 2
            color: root.fg
            iconSize: root.size
            text: root.icon
        }
    }
}
