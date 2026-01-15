pragma ComponentBehavior: Bound

import qs.modules.end4
import qs.modules.common

import QtQuick
import Quickshell.Widgets

Rectangle {
    id: root

    required property var active
    required property real borderRadius
    required property color bg

    radius: borderRadius
    topRightRadius: Appearance.space.big
    bottomRightRadius: Appearance.space.big
    color: bg

    Rectangle {
        id: preview
        x: Appearance.space.big
        y: Appearance.space.big
        implicitHeight: parent.height - (Appearance.space.big * 2)
        implicitWidth: parent.width - (Appearance.space.big * 2)
        color: Appearance.material.myBackground
        radius: Appearance.round.big
        topRightRadius: Appearance.space.small
        bottomRightRadius: Appearance.space.small

        Loader {
            active: !root.active?.mime?.startsWith("image/")
            sourceComponent: StyledText {
                x: Appearance.space.small
                y: Appearance.space.small
                width: preview.width - (Appearance.space.small * 2)
                wrapMode: Text.WordWrap
                text: root.active?.text ?? ""
            }
        }

        Loader {
            active: !!root.active?.mime?.startsWith("image/")
            sourceComponent: ClippingRectangle {
                implicitHeight: preview.height
                implicitWidth: preview.width
                radius: Appearance.round.large
                StyledImage {
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectCrop
                    source: root.active?.image ?? ""
                }
            }
        }
    }
}
