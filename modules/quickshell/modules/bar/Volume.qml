import qs.modules.common

import QtQuick
import QtQuick.Layouts
import Quickshell
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
                    return "";
                } else if (vol <= 0.5) {
                    return "";
                } else {
                    return "";
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
                family: Appearance.font.icon
                pixelSize: 14
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
                family: Appearance.font.main
                bold: true
                pixelSize: 14
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
