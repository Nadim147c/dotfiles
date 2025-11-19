import qs.modules.common
import qs.modules.end4

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

ClippingRectangle {
    implicitHeight: body.height
    implicitWidth: body.width
    radius: Appearance.round.larger
    color: "transparent"
    RowLayout {
        id: body
        spacing: Appearance.space.little

        //  PREVIOUS BUTTON
        Rectangle {
            id: previous
            implicitHeight: Appearance.space.large * 2.5
            implicitWidth: Appearance.space.large * 2.5
            radius: Appearance.round.medium

            property bool pressedBounce: false

            color: previousMouse.containsMouse ? Appearance.material.myTertiary : Appearance.material.myPrimaryContainer

            Behavior on color {
                ColorAnimation {
                    duration: Appearance.time.quick
                }
            }

            Text {
                text: "skip_previous"
                anchors.centerIn: parent
                color: previousMouse.containsMouse ? Appearance.material.myOnTertiary : Appearance.material.myOnPrimaryContainer
                Behavior on color {
                    ColorAnimation {
                        duration: Appearance.time.quick
                    }
                }

                font {
                    family: Appearance.font.family.iconMaterial
                    pixelSize: Appearance.font.pixelSize.huge
                }
            }

            MouseArea {
                id: previousMouse
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onClicked: WaybarLyric.previous()
            }
        }

        //  PLAY / PAUSE BUTTON
        Rectangle {
            id: playPause
            property bool playing: WaybarLyric.lyrics.info.status == "Playing"
            implicitHeight: Appearance.space.large * 2.5
            implicitWidth: playing ? Appearance.space.large * 2.5 : Appearance.space.large * 3.5
            radius: playing ? Appearance.round.medium : Appearance.round.larger
            Behavior on radius {
                NumberAnimation {
                    duration: Appearance.time.swift
                    easing.type: Easing.InOutQuad
                }
            }

            color: {
                if (playPauseMouse.containsMouse) {
                    return Appearance.material.myTertiary;
                } else if (playing) {
                    return Appearance.material.myPrimaryContainer;
                } else {
                    return Appearance.material.mySecondary;
                }
            }
            Behavior on color {
                ColorAnimation {
                    duration: Appearance.time.swift
                }
            }

            Text {
                text: parent.playing ? "pause" : "play_arrow"
                anchors.centerIn: parent
                color: {
                    if (playPauseMouse.containsMouse) {
                        return Appearance.material.myOnSecondary;
                    } else if (parent.playing) {
                        return Appearance.material.myOnPrimaryContainer;
                    } else {
                        return Appearance.material.myOnTertiary;
                    }
                }
                Behavior on color {
                    ColorAnimation {
                        duration: Appearance.time.quick
                    }
                }

                font {
                    family: Appearance.font.family.iconMaterial
                    pixelSize: Appearance.font.pixelSize.huge
                }
            }

            Behavior on implicitWidth {
                SpringAnimation {
                    duration: 150
                    spring: 4
                    damping: 0.2
                    mass: 1
                }
            }

            MouseArea {
                id: playPauseMouse
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onClicked: WaybarLyric.playpause()
            }
        }

        // ============================
        //  NEXT BUTTON
        // ============================
        Rectangle {
            id: next
            implicitHeight: Appearance.space.large * 2.5
            implicitWidth: Appearance.space.large * 2.5
            radius: Appearance.round.medium

            color: nextMouse.containsMouse ? Appearance.material.myTertiary : Appearance.material.myPrimaryContainer
            Behavior on color {
                ColorAnimation {
                    duration: Appearance.time.quick
                }
            }

            Text {
                text: "skip_next"
                anchors.centerIn: parent
                color: nextMouse.containsMouse ? Appearance.material.myOnTertiary : Appearance.material.myOnPrimaryContainer
                Behavior on color {
                    ColorAnimation {
                        duration: Appearance.time.quick
                    }
                }

                font {
                    family: Appearance.font.family.iconMaterial
                    pixelSize: Appearance.font.pixelSize.huge
                }
            }

            MouseArea {
                id: nextMouse
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onClicked: WaybarLyric.next()
            }
        }
    }
}
