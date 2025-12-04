import qs.modules.end4
import QtQuick

Item {
    id: root
    required property string mime
    required property string content

    height: 120

    Loader {
        active: mime.startsWith("image/")
        sourceComponent: StyledImage {
            width: root.width
            height: root.height
            fillMode: Image.PreserveAspectCrop
            source: root.content
        }
    }
}
