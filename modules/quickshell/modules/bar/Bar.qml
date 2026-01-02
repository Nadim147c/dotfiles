import qs.modules.common

import QtQuick
import QtQuick.Shapes
import QtQuick.Layouts
import Quickshell

PanelWindow {
    id: root
    anchors {
        left: true
        top: true
        right: true
    }
    aboveWindows: false

    color: "transparent"
    property color bg: Appearance.material.myBackground

    property real barSize: body.height
    property real borderRadius: Appearance.space.large
    implicitHeight: barSize + borderRadius
    exclusiveZone: barSize

    Shape {
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            strokeWidth: 0
            fillColor: root.bg
            startX: 0
            startY: root.barSize
            PathLine {
                x: 0
                y: root.height
            }
            PathArc {
                x: root.borderRadius
                y: root.barSize
                radiusX: root.borderRadius
                radiusY: root.borderRadius
                direction: PathArc.Clockwise
            }
            PathLine {
                x: root.width - root.borderRadius
                y: root.barSize
            }
            PathArc {
                x: root.width
                y: root.height
                radiusX: root.borderRadius
                radiusY: root.borderRadius
                direction: PathArc.Clockwise
            }
            PathLine {
                x: root.width
                y: root.barSize
            }
        }
    }

    Rectangle {
        id: body
        implicitHeight: 32
        implicitWidth: parent.width
        color: root.bg

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
                    spacing: Appearance.space.tiny
                    BarWorkspaces {}
                    BarLyrics {}
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
                    spacing: Appearance.space.tiny
                    anchors.fill: parent
                    BarCPU {}
                    BarNetwork {}
                    BarVolume {}
                    BarClock {}
                    BarTray {}
                }
            }
        }
    }
}
