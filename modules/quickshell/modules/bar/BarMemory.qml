import qs.modules.common
import qs.modules.end4

import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    implicitWidth: progress.width + (Appearance.space.small * 2)
    implicitHeight: progress.height

    readonly property real high: 0.7
    function clamp(n) {
        return Math.min(Math.max(n, 0), 1);
    }
    property real usages: clamp(1 - (SystemUsage.memAvailable / SystemUsage.memTotal)) || 0

    Behavior on color {
        ColorAnimation {
            duration: Appearance.time.quick
        }
    }

    color: "transparent"

    property color fg: {
        if (root.usages > root.high) {
            return Appearance.material.myError;
        } else {
            return Appearance.material.myPrimary;
        }
    }

    CircularProgress {
        id: progress
        anchors.centerIn: parent
        lineWidth: 2
        implicitSize: 24
        gapAngle: 10
        colPrimary: root.fg
        colSecondary: Appearance.material.mySurfaceVariant
        value: root.usages
        wavy: true
        waveHeight: 1.2
        waveFrequency: 10
    }

    MouseArea {
        id: mouseArea
        anchors.fill: progress
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
    }

    MaterialSymbol {
        text: "memory_alt"
        anchors.centerIn: parent
        color: root.fg
        iconSize: 12
    }

    StyledToolTip {
        text: `${SystemUsage.memAvailableString} is available from ${SystemUsage.memTotalString}`
        extraVisibleCondition: mouseArea.containsMouse
    }
}
