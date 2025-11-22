import qs.modules.common

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Services.SystemTray

Rectangle {
    id: root
    implicitWidth: body.width + (Appearance.space.medium * 2)
    implicitHeight: parent.height
    radius: Appearance.round.medium

    color: Appearance.material.mySurfaceContainerHighest

    RowLayout {
        id: body
        y: (root.height - height) / 2
        x: Appearance.space.medium
        Repeater {
            model: SystemTray.items
            MouseArea {
                width: 20
                height: 18
                IconImage {
                    anchors.fill: parent
                    source: modelData.icon
                }
            }
        }
    }
}
