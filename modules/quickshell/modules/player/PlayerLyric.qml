import qs.modules.common
import qs.modules.end4

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

MouseArea {
    id: lyricMouse
    visible: WaybarLyric.lyrics.context.length !== 0
    implicitWidth: parent.width
    implicitHeight: 200
    hoverEnabled: true
    ScrollView {
        id: lyricView
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
                model: WaybarLyric.lyrics.context
                MouseArea {
                    id: lyricLine
                    implicitHeight: lyricLineText.height
                    implicitWidth: lyricView.width
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
                            if (!active || lyricMouse.containsMouse)
                                return;
                            const linePos = lyricLine.y - (lyricView.height / 2);
                            let pos;
                            if (lyricColumn.height - linePos < lyricView.height) {
                                pos = lyricColumn - lyricView.height;
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
}
