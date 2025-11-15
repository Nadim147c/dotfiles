import qs.modules.common

import QtQuick
import QtQuick.Layouts
import Quickshell

PanelWindow {
    anchors {
        left: true
        top: true
        right: true
    }
    margins {
        left: Appearance.space.medium
        top: Appearance.space.medium
        right: Appearance.space.medium
        bottom: Appearance.space.medium
    }

    color: "transparent"
    implicitHeight: 32

    Rectangle {
        anchors.fill: parent
        radius: Appearance.round.large
        color: Appearance.material.myBackground

        RowLayout {
            id: rootRow
            anchors {
                fill: parent
                margins: Appearance.space.little
            }

            Rectangle {
                color: "transparent"
                implicitHeight: rootRow.height
                implicitWidth: leftModule.implicitWidth
                RowLayout {
                    id: leftModule
                    anchors.fill: parent
                    Workspace {}
                    Lyrics {}
                }
            }

            // Spacer to push the next item to the right
            Item {
                Layout.fillWidth: true
            }

            Rectangle {
                color: "transparent"
                implicitHeight: rootRow.height
                implicitWidth: rightModule.implicitWidth
                RowLayout {
                    id: rightModule
                    anchors.fill: parent
                    Network {}
                    Volume {}
                    Clock {}
                }
            }
        }
    }
}
