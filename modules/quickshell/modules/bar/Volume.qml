import qs.modules.common

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
            return "transparent";
        }
    }

    radius: Appearance.round.big

    RowLayout {
        id: volume
        y: (parent.height - volume.implicitHeight) / 2
        x: Appearance.space.medium

        spacing: Appearance.space.little
        Text {
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
            color: {
                if (mouseArea.containsMouse) {
                    return Appearance.material.myOnPrimary;
                } else {
                    return Appearance.material.myPrimary;
                }
            }
            font {
                family: Appearance.font.family.iconMaterial
                pixelSize: Appearance.font.pixelSize.normal
            }
        }
        Text {
            text: Math.round((Pipewire.defaultAudioSink?.audio.volume ?? 0) * 100).toString() + "%"
            color: {
                if (mouseArea.containsMouse) {
                    return Appearance.material.myOnPrimary;
                } else {
                    return Appearance.material.myPrimary;
                }
            }

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
