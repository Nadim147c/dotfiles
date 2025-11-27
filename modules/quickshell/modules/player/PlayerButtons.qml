import qs.modules.common
import qs.modules.end4

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

Rectangle {
    id: root
    implicitHeight: body.height
    implicitWidth: body.width
    color: "transparent"
    property real buttonHeight: Appearance.space.large * 4

    RowLayout {
        id: body
        spacing: Appearance.space.little

        PlayerButton {
            iconName: "skip_previous"
            buttonHeight: root.buttonHeight
            buttonWidth: 30
            buttonRadius: Appearance.round.larger * 2
            onReleased: WaybarLyric.player.previous()
        }
        PlayerButton {
            iconName: WaybarLyric.isPlaying ? "pause" : "play_arrow"
            buttonRadius: WaybarLyric.isPlaying ? Appearance.round.larger * 2 : Appearance.round.large
            toggled: !WaybarLyric.isPlaying
            onReleased: WaybarLyric.player.togglePlaying()
            buttonHeight: root.buttonHeight
            buttonWidth: root.buttonHeight
        }
        PlayerButton {
            iconName: "skip_next"
            buttonRadius: Appearance.round.larger * 2
            buttonHeight: root.buttonHeight
            buttonWidth: 30
            onReleased: WaybarLyric.player.next()
        }
    }
}
