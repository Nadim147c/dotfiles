import qs.modules.common
import qs.modules.end4
import qs.modules.end4.functions

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland
import Quickshell.Wayland

PanelWindow {
    id: player
    anchors {
        left: true
        top: true
    }

    margins {
        left: 120
    }

    implicitWidth: body.width
    implicitHeight: Math.max(500, body.height)

    WlrLayershell.namespace: "quickshell:player"

    aboveWindows: true

    color: "transparent"

    HyprlandFocusGrab {
        windows: [player]
        active: Toggle.player
        onCleared: Toggle.player = false
    }

    ClippingRectangle {
        id: body
        implicitWidth: content.width + (Appearance.space.large * 2)
        implicitHeight: content.height + (Appearance.space.large * 2)

        radius: Appearance.round.larger
        color: Appearance.player.mySurface

        Item {
            width: parent.width
            height: control.height + (Appearance.space.large * 2)
            StyledImage {
                id: coverArt
                anchors.fill: parent
                source: WaybarLyric.cover
                fillMode: Image.PreserveAspectCrop
            }

            Rectangle {
                anchors.top: parent.top
                width: parent.width
                height: 100
                gradient: Gradient {
                    GradientStop {
                        position: 1
                        color: ColorUtils.transparentize(Appearance.player.mySurface)
                    }
                    GradientStop {
                        position: 0
                        color: ColorUtils.transparentize(Appearance.player.mySurface, 0.2)
                    }
                }
            }

            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: 100
                gradient: Gradient {
                    GradientStop {
                        position: 0
                        color: ColorUtils.transparentize(Appearance.player.mySurface)
                    }
                    GradientStop {
                        position: 1
                        color: Appearance.player.mySurface
                    }
                }
            }
        }

        ColumnLayout {
            id: content
            x: Appearance.space.large
            y: Appearance.space.large
            spacing: 0

            ColumnLayout {
                id: control
                implicitWidth: 250

                spacing: Appearance.space.small
                Item {
                    implicitHeight: trackTitle.height
                    implicitWidth: 250
                    StyledText {
                        id: trackTitle
                        width: parent.width
                        font.pixelSize: Appearance.font.pixelSize.large
                        color: Appearance.player.myOnSurface
                        text: WaybarLyric.title || "Untitled"
                        elide: Text.ElideRight
                        animateChange: true
                        animationDistanceX: 6
                        animationDistanceY: 0
                    }
                }
                StyledText {
                    id: trackArtist
                    Layout.fillWidth: true
                    font.pixelSize: Appearance.font.pixelSize.smaller
                    color: Appearance.player.myOnSurface
                    text: WaybarLyric.artist || "Untitled"
                    elide: Text.ElideRight
                    animateChange: true
                    animationDistanceX: 6
                    animationDistanceY: 0
                }

                Item {
                    height: Appearance.space.larger * 2
                }

                RowLayout {
                    Item {
                        Layout.fillWidth: true
                    }
                    PlayerButtons {}
                    Item {
                        Layout.fillWidth: true
                    }
                }

                // Spacer to push the next item to the right
                Item {
                    id: progressBarContainer
                    implicitWidth: 300
                    implicitHeight: sliderLoader.implicitHeight

                    Loader {
                        id: sliderLoader
                        anchors.fill: parent
                        sourceComponent: StyledSlider {
                            wavy: WaybarLyric.isPlaying
                            waveFrequency: 10
                            waveAmplitudeMultiplier: 0.1
                            configuration: StyledSlider.Configuration.Wavy
                            highlightColor: Appearance.player.myPrimary
                            handleColor: Appearance.player.myPrimary
                            trackColor: Appearance.player.myOnPrimaryFixedVariant
                            value: WaybarLyric.player?.position / WaybarLyric.player?.length
                            onMoved: {
                                WaybarLyric.player.position = value * WaybarLyric.player.length;
                            }
                        }
                    }
                }
            }

            Item {
                visible: WaybarLyric.lines.length !== 0
                Layout.fillWidth: true
                height: Appearance.space.large
            }

            Revealer {
                reveal: WaybarLyric.lines.length !== 0
                vertical: true
                PlayerLyrics {
                    id: lyrics
                    implicitWidth: content.width
                }
            }
        }
    }
    MouseArea {
        anchors.bottom: parent.bottom
        implicitWidth: parent.width
        implicitHeight: parent.height - body.height
        onClicked: Toggle.player = false
    }
}
