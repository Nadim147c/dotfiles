import qs.modules.common

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

MouseArea {
    id: root
    implicitWidth: parent.width
    implicitHeight: 200
    hoverEnabled: true

    property bool atTop: lyricsBar.position === 0
    property bool atBottom: 0.99 - (view.height / lyricColumn.height) <= lyricsBar.position

    ScrollView {
        id: view
        width: parent.width
        implicitHeight: 200
        contentWidth: width
        ScrollBar.vertical: ScrollBar {
            id: lyricsBar
            policy: ScrollBar.AlwaysOff
            Behavior on position {
                NumberAnimation {
                    duration: Appearance.time.normal
                    easing.type: Appearance?.animation.elementMoveFast.type ?? Easing.BezierSpline
                    easing.bezierCurve: Appearance?.animation.elementMoveFast.bezierCurve ?? [0.34, 0.80, 0.34, 1.00, 1, 1]
                }
            }
        }

        ColumnLayout {
            id: lyricColumn
            width: parent.width

            Repeater {
                model: WaybarLyric.lines
                MouseArea {
                    id: lyricLine
                    implicitHeight: lyricLineText.height
                    implicitWidth: view.width
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: WaybarLyric.setPosition(modelData.time)

                    required property int index
                    required property var modelData

                    Text {
                        id: lyricLineText
                        property bool active: lyricLine.index === WaybarLyric.lineIndex
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: lyricLine.modelData.line || "󰎇"
                        color: active ? Appearance.player.myOnSurface : Appearance.player.myOutline
                        Behavior on color {
                            ColorAnimation {
                                duration: Appearance.time.quick
                            }
                        }
                        onActiveChanged: {
                            if (!active || root.containsMouse)
                                return;
                            const linePos = lyricLine.y + lyricLine.height - (view.height / 2);
                            let pos;
                            if (lyricColumn.height - linePos < view.height) {
                                pos = (lyricColumn.height - view.height) / lyricColumn.height;
                            } else {
                                pos = linePos / lyricColumn.height;
                            }
                            lyricsBar.position = Math.max(pos, 0);
                        }
                        font {
                            family: Appearance.font.family.main
                            pixelSize: Appearance.font.pixelSize.small
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        anchors.top: parent.top
        width: parent.width
        height: 20
        opacity: root.atTop ? 0 : 1
        Behavior on opacity {
            NumberAnimation {
                duration: Appearance.time.swift
                easing.type: Easing.InOutQuad
            }
        }
        gradient: Gradient {
            GradientStop {
                position: 0
                color: Appearance.player.mySurface
            }
            GradientStop {
                position: 0.95
                color: Appearance.player.mySurface + "00"
            }
        }
    }

    Rectangle {
        anchors.bottom: parent.bottom
        width: parent.width
        height: 20
        opacity: root.atBottom ? 0 : 1
        Behavior on opacity {
            NumberAnimation {
                duration: Appearance.time.swift
                easing.type: Easing.InOutQuad
            }
        }
        gradient: Gradient {
            GradientStop {
                position: 0
                color: Appearance.player.mySurface + "00"
            }
            GradientStop {
                position: 0.95
                color: Appearance.player.mySurface
            }
        }
    }
}
