import qs.modules.common

import QtQuick
import Quickshell.Hyprland
import Quickshell.Widgets

ClippingRectangle {
    id: root
    color: "transparent"
    radius: Appearance.round.large
    clip: true

    implicitWidth: workspaces.width
    implicitHeight: parent.height

    Row {
        id: workspaces
        spacing: Appearance.space.visible

        Repeater {
            model: Hyprland.workspaces

            MouseArea {
                id: workspace
                cursorShape: Qt.PointingHandCursor

                required property var modelData

                height: root.height
                width: {
                    if (workspace.modelData.active) {
                        return root.height + Appearance.space.small;
                    } else {
                        return root.height;
                    }
                }

                Behavior on width {
                    SpringAnimation {
                        duration: 200
                        spring: 4     // stiffness
                        damping: 0.2    // lower = more overshoot
                        mass: 1
                    }
                }

                onClicked: {
                    onClicked: modelData.activate();
                }

                hoverEnabled: true
                enabled: true

                Rectangle {
                    id: workspaceRect
                    anchors.fill: parent
                    color: {
                        if (workspace.containsMouse || workspace.modelData.urgent) {
                            return Appearance.material.mySecondary;
                        } else if (workspace.modelData.active) {
                            return Appearance.material.myPrimary;
                        } else {
                            return Appearance.material.mySurfaceContainerHighest;
                        }
                    }
                    radius: {
                        if (workspace.modelData.active) {
                            return Appearance.round.large;
                        } else {
                            return Appearance.round.small;
                        }
                    }
                    Behavior on radius {
                        SpringAnimation {
                            duration: 200
                            spring: 4     // stiffness
                            damping: 0.2    // lower = more overshoot
                            mass: 1
                        }
                    }
                }

                Text {
                    id: workspaceName
                    anchors.centerIn: workspaceRect
                    text: workspace.modelData.name
                    font.family: Appearance.font.main
                    font.bold: true
                    font.pixelSize: 13
                    color: {
                        if (workspace.containsMouse || workspace.modelData.urgent) {
                            return Appearance.material.myOnSecondary;
                        } else if (workspace.modelData.active) {
                            return Appearance.material.myOnPrimary;
                        } else {
                            return Appearance.material.myOnSurface;
                        }
                    }
                }
            }
        }
    }
}
