import qs.modules.common

import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Widgets

RowLayout {
    id: root
    spacing: 2
    height: parent.height

    Repeater {
        model: Hyprland.workspaces

        MouseArea {
            id: workspace
            cursorShape: Qt.PointingHandCursor

            required property var modelData

            implicitHeight: root.height
            implicitWidth: root.height + Appearance.space.small

            onClicked: modelData.activate()

            hoverEnabled: true
            enabled: true

            property color bg: {
                if (workspace.containsMouse) {
                    return Appearance.material.myTertiary;
                } else if (workspace.modelData.urgent) {
                    return Appearance.material.mySecondary;
                } else if (workspace.modelData.active) {
                    return Appearance.material.myPrimary;
                } else {
                    return Appearance.material.mySurfaceVariant;
                }
            }
            property color fg: {
                if (workspace.containsMouse) {
                    return Appearance.material.myOnTertiary;
                } else if (workspace.modelData.urgent) {
                    return Appearance.material.myOnSecondary;
                } else if (workspace.modelData.active) {
                    return Appearance.material.myOnPrimary;
                } else {
                    return Appearance.material.myOnSurfaceVariant;
                }
            }
            Behavior on bg {
                ColorAnimation {
                    duration: Appearance.time.quick
                }
            }

            Behavior on fg {
                ColorAnimation {
                    duration: Appearance.time.quick
                }
            }
            Rectangle {
                anchors.fill: parent
                color: workspace.bg
                radius: {
                    if (workspace.modelData.active) {
                        return Appearance.round.small;
                    } else {
                        return Appearance.round.big;
                    }
                }
                Behavior on radius {
                    animation: Appearance.animation.elementMove.numberAnimation.createObject(this)
                }
            }

            Item {
                anchors.fill: parent
                Text {
                    x: (parent.width - width) / 2
                    y: (parent.height - height) / 2
                    text: workspace.modelData.name
                    color: workspace.fg
                    font {
                        family: Appearance.font.family.reading
                        pixelSize: Appearance.font.pixelSize.normal
                        bold: true
                        variableAxes: Appearance.font?.variableAxes?.numbers
                    }
                }
            }
        }
    }
}
