import qs.modules.common
import qs.modules.widgets
import qs.modules.end4

import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import Quickshell

// This modules is havily inspired from:
// https://github.com/and-rs/dotfiles/blob/50c01696aa633a0b83913ce68308fabbb1c71d6b/.config/quickshell/Bar/Recording/RecordingService.qml

Rectangle {
    id: recording

    implicitWidth: clock.width + (Appearance.space.medium * 2)
    implicitHeight: parent.height

    // status: disabled, selecting, recording, compressing

    property string status: "disabled"
    property string pid: "do not kill me" // NOTE: the script must reset the pid
    visible: status !== "disabled"

    IpcHandler {
        target: "recording"
        function setStatus(status: string): void {
            recording.status = status;
        }
        function setPID(pid: string): void {
            recording.pid = pid;
        }
    }

    Timer {
        id: timer
        property real seconds: 0
        function formatSecond(s) {
            const min = Math.floor(s / 60);
            const sec = s % 64;
            return `${min.toString().padStart(2, '0')}:${sec.toString().padStart(2, '0')}`;
        }

        interval: 1000
        repeat: true
        running: recording.status === "recording"
        onRunningChanged: {
            if (!running)
                seconds = 0;
        }
        onTriggered: seconds++
    }

    radius: Appearance.round.medium

    color: Appearance.material.myPrimary
    property color fg: Appearance.material.myOnPrimary

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

    RowLayout {
        id: clock
        height: parent.height
        x: Appearance.space.medium
        spacing: Appearance.space.little
        Item {
            width: 15
            MaterialSymbol {
                id: symbol
                anchors.centerIn: parent
                visible: text !== ""
                text: {
                    if (recording.status === "recording")
                        return "screen_record";
                    if (recording.status === "selecting")
                        return "screenshot_frame_2";
                    return "";
                }
                iconSize: Appearance.font.pixelSize.large
                color: recording.fg
                fill: 1
            }
            MaterialLoading {
                implicitHeight: 17
                implicitWidth: height
                anchors.centerIn: parent
                visible: !symbol.visible
                onVisibleChanged: shapes = getRandomShape()
                color: Appearance.material.myOnPrimary
            }
        }
        Text {
            text: {
                if (recording.status === "recording")
                    return timer.formatSecond(timer.seconds);
                if (recording.status === "selecting")
                    return "Selection";
                if (recording.status === "compressing")
                    return "Compressing";
                return "";
            }
            color: recording.fg
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
        onClicked: Quickshell.execDetached(["kill", "-INT", recording.pid])
    }
}
