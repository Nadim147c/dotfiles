pragma ComponentBehavior: Bound

import qs.modules.common

import QtQuick
import Quickshell
import Quickshell.Widgets

Loader {
    id: root

    required property int index
    required property int activeIndex
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

    property real padding: (current && index != 0 || activeIndex == 0 && index == 1) ? Appearance.space.big : 0
    Behavior on width {
        animation: Appearance.animation.elementMove.numberAnimation.createObject(this)
    }
    Behavior on padding {
        animation: Appearance.animation.elementMove.numberAnimation.createObject(this)
    }

    active: current || neighbor || secondNeighbor

    sourceComponent: Rectangle {
        anchors.fill: parent
        color: "transparent"
        ClippingRectangle {
            width: parent.width - (root.padding * 2)
            x: root.padding
            height: parent.height
            radius: Appearance.round.big

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
}
