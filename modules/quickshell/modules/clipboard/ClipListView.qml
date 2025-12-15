import qs.modules.common
import qs.modules.end4

import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets

ClippingRectangle {
    id: root

    property list<QtObject> clipboard
    property int currentIndex: 0
    signal itemSelected

    Layout.fillWidth: true
    Layout.fillHeight: true

    radius: Appearance.round.medium
    color: "transparent"

    Component {
        id: clip
        Rectangle {
            width: parent.width
            height: 25
            radius: Appearance.space.small
            color: ListView.isCurrentItem ? Appearance.material.mySurfaceVariant : "transparent"
            StyledText {
                x: Appearance.space.big
                width: parent.width - (Appearance.space.small * 2)
                anchors.verticalCenter: parent.verticalCenter
                color: Appearance.material.myOnSurfaceVariant
                font.pixelSize: Appearance.font.pixelSize.smallie
                elide: Text.ElideRight
                text: preview
                textFormat: Text.PlainText
            }
        }
    }

    ListView {
        id: listview
        anchors.fill: parent
        spacing: Appearance.space.visible
        model: root.clipboard
        currentIndex: root.currentIndex

        delegate: clip
    }
}
