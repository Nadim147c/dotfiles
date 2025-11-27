import qs.modules.end4

import QtQuick

Item {
    id: root

    required property string mime
    required property string content

    height: 30

    Loader {
        id: textLoader
        anchors.fill: parent
        active: root.mime === "text"
        sourceComponent: StyledText {
            anchors.verticalCenter: parent.verticalCenter
            width: root.width
            elide: Text.ElideRight
            text: root.content
        }
    }
}
