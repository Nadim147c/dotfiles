import qs.modules.common
import qs.modules.end4

import QtQuick

Rectangle {
    id: root

    implicitWidth: progress.width
    implicitHeight: progress.height

    readonly property real high: 70

    Behavior on color {
        ColorAnimation {
            duration: Appearance.time.quick
        }
    }

    color: "transparent"

    property color fg: {
        if (SystemUsage.cpuUtilization > root.high) {
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
        value: SystemUsage.cpuUtilization / 100
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
        text: "memory"
        anchors.centerIn: parent
        color: root.fg
        iconSize: 12
        fill: 1
    }

    StyledToolTip {
        text: `${SystemUsage.cpuUtilizationString}% CPU Usages`
        extraVisibleCondition: mouseArea.containsMouse
    }
}
