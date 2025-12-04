import qs.modules.common
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
        active: root.mime.startsWith("text")
        sourceComponent: StyledText {
            color: Appearance.material.myOnSurfaceVariant
            anchors.verticalCenter: parent.verticalCenter
            width: root.width
            font.pixelSize: Appearance.font.pixelSize.smallie
            elide: Text.ElideRight
            text: root.content
        }
    }
}
