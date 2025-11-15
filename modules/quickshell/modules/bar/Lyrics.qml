import qs.modules.common

import QtQuick
import QtQuick.Layouts
import Quickshell

Rectangle {
    id: root
    implicitWidth: lyrics.width + (Appearance.space.medium * 2)
    implicitHeight: parent.height
    radius: Appearance.round.big

    color: lyricArea.containsMouse ? Appearance.material.myPrimary : "transparent"

    property color fg: {
        if (lyricArea.containsMouse) {
            return Appearance.material.myOnPrimary;
        } else if (WaybarLyric.lyrics.info.status == "Paused") {
            return Appearance.material.myOutline;
        } else {
            return Appearance.material.myPrimary;
        }
    }

    Behavior on color {
        ColorAnimation {
            duration: Appearance.time.quick
        }
    }
    Behavior on fg {
        ColorAnimation {
            duration: Appearance.time.quick
        }
    }

    MouseArea {
        id: lyricArea
        y: (parent.height - lyrics.implicitHeight) / 2
        x: Appearance.space.medium

        implicitWidth: lyrics.implicitWidth + (Appearance.space.little * 2)
        implicitHeight: parent.height

        cursorShape: Qt.PointingHandCursor

        hoverEnabled: true
        enabled: true

        onClicked: {
            onClicked: Quickshell.execDetached(["waybar-lyric", "play-pause"]);
        }

        RowLayout {
            id: lyrics

            spacing: Appearance.space.little
            Text {
                text: WaybarLyric.lyrics.icon
                visible: WaybarLyric.lyrics.icon.length != 0
                color: root.fg
                font {
                    family: Appearance.font.icon
                    pixelSize: 14
                }
            }
            Text {
                text: WaybarLyric.lyrics.text
                color: root.fg
                font {
                    family: Appearance.font.main
                    bold: WaybarLyric.lyrics.info.status != "Paused"
                    italic: WaybarLyric.lyrics.info.status == "Paused"
                    pixelSize: 14
                }
            }
        }
    }
}
