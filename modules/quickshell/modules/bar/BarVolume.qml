import qs.modules.common
import qs.modules.end4

import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire

Rectangle {
    id: root

    implicitWidth: volume.width + (Appearance.space.medium * 2)
    implicitHeight: parent.height
    color: {
        if (mouseArea.containsMouse) {
            return Appearance.material.myPrimary;
        } else {
            return Appearance.material.mySurfaceVariant;
        }
    }
    property color fg: {
        if (mouseArea.containsMouse) {
            return Appearance.material.myOnPrimary;
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

    radius: Appearance.round.large

    RowLayout {
        id: volume
        y: (parent.height - volume.implicitHeight) / 2
        x: Appearance.space.medium
        spacing: Appearance.space.little
        MaterialSymbol {
            text: {
                const vol = Pipewire.defaultAudioSink?.audio.volume;
                if (vol === 0) {
                    return "volume_mute";
                } else if (vol <= 0.5) {
                    return "volume_down";
                } else {
                    return "volume_up";
                }
            }
            color: root.fg
            iconSize: Appearance.font.pixelSize.large
            fill: 1
        }
        Text {
            text: Math.round((Pipewire.defaultAudioSink?.audio.volume ?? 0) * 100).toString() + "% " // extra space is intention
            color: root.fg
            font {
                family: Appearance.font.family.main
                pixelSize: Appearance.font.pixelSize.small
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onWheel: wheel => {
            try {
                if (wheel.angleDelta.y > 0) {
                    Pipewire.defaultAudioSink.audio.volume += 0.01;
                } else if (wheel.angleDelta.y < 0) {
                    Pipewire.defaultAudioSink.audio.volume -= 0.01;
                }
                wheel.accepted = true;
            } catch (e) {
                console.error(e);
            }
        }
    }
}
