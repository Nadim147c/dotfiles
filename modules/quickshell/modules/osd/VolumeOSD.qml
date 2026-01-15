import qs.modules.common
import qs.modules.end4

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Scope {
    id: root

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    Connections {
        target: Pipewire.defaultAudioSink?.audio

        function onVolumeChanged() {
            if (root.start) {
                root.start = false;
                return;
            }
            root.shouldShowOsd = true;
            hideTimer.restart();
        }
    }

    property bool shouldShowOsd: false
    property bool start: true

    Timer {
        id: hideTimer
        interval: 1000
        onTriggered: root.shouldShowOsd = false
    }

    LazyLoader {
        active: root.shouldShowOsd
        PanelWindow {
            anchors.bottom: true
            margins.bottom: screen.height / 15
            exclusiveZone: 0

            implicitWidth: 300
            implicitHeight: 45
            color: "transparent"

            // An empty click mask prevents the window from blocking mouse events.
            mask: Region {}

            Rectangle {
                radius: height / 2
                color: Appearance.material.myBackground
                anchors.fill: parent

                StyledSlider {
                    x: Appearance.space.large
                    y: (parent.height - height) / 2
                    width: parent.width - (Appearance.space.large * 2)
                    wavy: false
                    configuration: StyledSlider.Configuration.XS
                    highlightColor: Appearance.material.myPrimary
                    handleColor: Appearance.material.myPrimary
                    trackColor: Appearance.material.myOnPrimaryFixedVariant
                    value: Pipewire.defaultAudioSink?.audio.volume ?? 0
                }
            }
        }
    }
}
