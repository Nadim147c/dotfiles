import qs.modules.common
import qs.modules.end4

import QtQuick

Rectangle {
    id: root

    required property string icon
    signal clicked
    signal rightClicked

    implicitHeight: icon.height + (Appearance.space.small * 2)
    implicitWidth: icon.width + (Appearance.space.small * 2)
    color: mouse.containsMouse ? Appearance.material.myPrimary : Appearance.material.mySurfaceContainerHigh
    radius: Appearance.round.big

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
            x: Appearance.space.small
            y: Appearance.space.small
            color: mouse.containsMouse ? Appearance.material.myOnPrimary : Appearance.material.myPrimary
            iconSize: 24
            text: root.icon
        }
    }
}
