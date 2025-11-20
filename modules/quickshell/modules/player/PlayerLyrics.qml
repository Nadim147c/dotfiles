import qs.modules.common
import qs.modules.end4

import QtQuick
import QtQuick.Effects
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

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
                    easing.type: Easing.InOutQuad
                }
            }
        }

        ColumnLayout {
            id: lyricColumn
            width: parent.width

            Repeater {
                model: WaybarLyric.lyrics.lines
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
                        property bool active: lyricLine.index === WaybarLyric.lyrics.lineIndex
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: lyricLine.modelData.line || "󰎇"
                        color: active ? Appearance.material.myOnSurface : Appearance.material.myOutline
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
                color: Appearance.material.mySurface
            }
            GradientStop {
                position: 1
                color: Appearance.material.mySurface + "00"
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
                color: Appearance.material.mySurface + "00"
            }
            GradientStop {
                position: 1
                color: Appearance.material.mySurface
            }
        }
    }
}
