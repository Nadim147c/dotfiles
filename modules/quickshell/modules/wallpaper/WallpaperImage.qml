pragma ComponentBehavior: Bound

import qs.modules.common

import QtQuick
import Quickshell
import Quickshell.Widgets

Loader {
    id: root

    required property int index
    required property string preview
    required property string filename
    required property bool current
    required property bool neighbor
    required property bool secondNeighbor

    signal scroll(down: bool)

    property real activeWidth: 300
    property real inactiveWidth: activeWidth / 2

    width: current ? 300 : neighbor ? inactiveWidth : 0
    height: parent.height

    Behavior on width {
        NumberAnimation {
            duration: 200
            easing.type: Easing.InOutQuad
        }
    }

    active: current || neighbor || secondNeighbor

    sourceComponent: ClippingRectangle {
        anchors.fill: parent
        radius: Appearance.round.medium

        // Wheel interaction only if not fake item
        MouseArea {
            anchors.fill: parent
            enabled: true
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onWheel: wheel => {
                root.scroll(wheel.angleDelta.y > 0);
            }
            onClicked: {
                console.log(["wallpaper.sh", root.filename]);
                Quickshell.execDetached(["wallpaper.sh", root.filename]);
            }
            Image {
                anchors.fill: parent
                fillMode: Image.PreserveAspectCrop
                source: root.preview
            }
        }
    }
}
