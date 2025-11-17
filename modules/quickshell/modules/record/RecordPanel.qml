// RecordPanel.qml
import QtQuick
import QtQuick.Layouts
import Quickshell

PanelWindow {
    id: root
    property string timestamp: ""
    signal clickStop

    color: "transparent"

    implicitWidth: body.width
    implicitHeight: body.height
    anchors.bottom: true
    anchors.right: true
    margins {
        bottom: 24
        right: 24
    }

    Rectangle {
        id: body
        implicitWidth: row.width + 20
        implicitHeight: row.height + 10
        radius: 10
        color: mouseArea.containsMouse ? "#d32f2f" : "#212121"

        RowLayout {
            id: row
            x: 10
            spacing: 10

            Text {
                text: root.timestamp
                font.pixelSize: 18
                color: "white"
            }

            Text {
                text: "⏺"
                font.pixelSize: 24
                color: "red"
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.clickStop()
    }
}
