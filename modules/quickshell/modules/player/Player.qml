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
        left: 50
        top: 10
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

    mask: Region {
        item: body
    }

    ClippingRectangle {
        id: body
        implicitWidth: 450
        implicitHeight: content.height + (Appearance.space.large * 2)

        radius: Appearance.round.larger
        color: ColorUtils.transparentize(Appearance.player.myBackground, 0.15)

        ColumnLayout {
            id: content
            width: parent.width - (Appearance.space.large * 2)
            x: Appearance.space.large
            y: Appearance.space.large
            spacing: 0

            RowLayout {
                ClippingRectangle {
                    implicitWidth: 150
                    implicitHeight: 150
                    radius: Appearance.round.big
                    StyledImage {
                        id: coverArt
                        anchors.fill: parent
                        source: WaybarLyric.cover
                        fillMode: Image.PreserveAspectCrop
                    }
                }
                spacing: Appearance.space.large

                ColumnLayout {
                    id: control
                    width: content.width - coverArt.width - Appearance.space.large
                    Item {
                        implicitWidth: control.width
                        implicitHeight: trackTitle.height
                        StyledText {
                            id: trackTitle
                            width: control.width
                            font.pixelSize: Appearance.font.pixelSize.large
                            horizontalAlignment: Text.AlignHCenter
                            color: Appearance.player.myOnBackground
                            text: WaybarLyric.title || "Untitled"
                            elide: Text.ElideRight
                            animateChange: true
                            animationDistanceX: 6
                            animationDistanceY: 0
                        }
                    }
                    Item {
                        implicitWidth: control.width
                        implicitHeight: trackArtist.height
                        StyledText {
                            id: trackArtist
                            width: control.width
                            horizontalAlignment: Text.AlignHCenter
                            font.pixelSize: Appearance.font.pixelSize.smaller
                            color: Appearance.player.myOnSurfaceVariant
                            text: `${WaybarLyric.artist || "Untitled"} - ${WaybarLyric.album || "Single"}`
                            elide: Text.ElideRight
                            animateChange: true
                            animationDistanceX: 6
                            animationDistanceY: 0
                        }
                    }
                    Item {
                        implicitHeight: buttons.height
                        implicitWidth: control.width
                        PlayerButtons {
                            id: buttons
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                    // Spacer to push the next item to the right
                    Item {
                        id: progressBarContainer
                        Layout.fillWidth: true
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
            }

            Item {
                visible: WaybarLyric.lines.length !== 0
                Layout.fillWidth: true
                height: Appearance.space.little
            }

            Revealer {
                reveal: WaybarLyric.lines.length !== 0
                vertical: true
                Item {
                    implicitHeight: lyrics.height + Appearance.space.big
                    implicitWidth: content.width
                    PlayerLyrics {
                        id: lyrics
                        y: Appearance.space.big
                        implicitWidth: content.width
                    }
                }
            }
        }
    }
}
