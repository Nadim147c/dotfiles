import qs.modules.common

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

PanelWindow {
    id: root
    anchors.bottom: true

    implicitWidth: 400
    implicitHeight: 5

    aboveWindows: true
    exclusionMode: ExclusionMode.Ignore

    color: "transparent"

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onHoveredChanged: Toggle.dock = true
    }
}
