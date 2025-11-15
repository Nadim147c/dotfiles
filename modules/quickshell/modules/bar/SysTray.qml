import qs.modules.common
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland
import Quickshell.Services.SystemTray

Rectangle {
    id: panel
    implicitWidth: parent.height
    implicitHeight: parent.height
    radius: Appearance.round.medium

    color: Appearance.material.mySurfaceContainerHighest

    Text {
        id: triggerText
        text: "󱊖"
        font.family: Appearance.font.icon
        font.bold: true
        anchors.centerIn: parent
        color: Appearance.material.myOnSurface
        font.pixelSize: 14
    }
}
