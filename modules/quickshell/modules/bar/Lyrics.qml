import qs.modules.common

import QtQuick
import QtQuick.Layouts
import Quickshell

Rectangle {
    id: root
    implicitWidth: lyrics.implicitWidth + (Appearance.space.little * 2)
    implicitHeight: parent.height
    radius: Appearance.round.medium

    color: {
        if (lyricArea.containsMouse) {
            return Appearance.material.myPrimary;
        } else {
            return "transparent";
        }
    }

    MouseArea {
        id: lyricArea
        y: (parent.height - lyrics.implicitHeight) / 2
        x: Appearance.space.little

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
                color: {
                    if (lyricArea.containsMouse) {
                        return Appearance.material.myOnPrimary;
                    } else if (WaybarLyric.lyrics.info.status == "Paused") {
                        return Appearance.material.myOutline;
                    } else {
                        return Appearance.material.myPrimary;
                    }
                }
                font {
                    family: Appearance.font.icon
                    pixelSize: 14
                }
            }
            Text {
                text: WaybarLyric.lyrics.text
                color: {
                    if (lyricArea.containsMouse) {
                        return Appearance.material.myOnPrimary;
                    } else if (WaybarLyric.lyrics.info.status == "Paused") {
                        return Appearance.material.myOutline;
                    } else {
                        return Appearance.material.myPrimary;
                    }
                }
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
