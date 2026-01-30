import qs.modules.common

import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

RowLayout {
    id: root
    spacing: 2
    height: parent.height

    signal firstActive(bool b)

    Repeater {
        model: Hyprland.workspaces

        MouseArea {
            id: workspace
            cursorShape: Qt.PointingHandCursor

            required property var modelData
            required property real index

            implicitHeight: root.height
            implicitWidth: root.height + Appearance.space.medium

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
                id: rect
                anchors.fill: parent
                color: workspace.bg

                property bool active: workspace.modelData.active
                property real roundness: Appearance.round.little
                property real targetRadius: workspace.modelData.active ? Appearance.round.large : Appearance.round.little
                onActiveChanged: {
                    radiusAnim.restart();
                    if (workspace.index == 0) {
                        root.firstActive(active);
                    }
                }

                property bool first: workspace.index == 0 && !active
                property bool last: (workspace.index + 1) == Hyprland.workspaces.values.length && !active

                bottomLeftRadius: first ? Appearance.round.large : roundness
                topLeftRadius: first ? Appearance.round.large : roundness
                bottomRightRadius: last ? Appearance.round.medium : roundness
                topRightRadius: last ? Appearance.round.medium : roundness

                SequentialAnimation {
                    id: radiusAnim
                    running: false

                    NumberAnimation {
                        target: rect
                        property: "roundness"
                        to: 1
                        duration: 100
                        easing.type: Easing.InQuad
                    }
                    NumberAnimation {
                        target: rect
                        property: "roundness"
                        to: rect.targetRadius
                        duration: 200
                        easing.type: Easing.OutQuad
                    }
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
