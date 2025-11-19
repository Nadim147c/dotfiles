import qs.modules.common
import qs.modules.end4

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland

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
    implicitHeight: body.height

    aboveWindows: true

    color: "transparent"

    HyprlandFocusGrab {
        windows: [player]
        active: Toggle.player
        onCleared: () => {
            Toggle.player = false;
        }
    }

    Rectangle {
        id: body
        implicitHeight: content.height + (Appearance.space.big * 2)
        implicitWidth: content.width + (Appearance.space.big * 2)
        radius: Appearance.round.larger
        color: Appearance.material.mySurface

        ColumnLayout {
            id: content
            x: Appearance.space.big
            y: Appearance.space.big
            spacing: Appearance.space.large
            RowLayout {
                id: controls
                spacing: Appearance.space.big
                Item {
                    width: 120
                    height: 120
                    ClippingRectangle {
                        anchors.fill: parent
                        radius: Appearance.round.large

                        // The image (just a normal Image)
                        Image {
                            id: coverArt
                            anchors.fill: parent
                            source: WaybarLyric.lyrics.info.cover
                            fillMode: Image.PreserveAspectCrop
                        }
                    }
                }

                ColumnLayout {
                    implicitWidth: 250
                    Item {
                        height: Appearance.space.small
                    }

                    spacing: Appearance.space.little
                    Item {
                        implicitHeight: trackTitle.height
                        implicitWidth: 250
                        StyledText {
                            id: trackTitle
                            width: parent.width
                            font.pixelSize: Appearance.font.pixelSize.large
                            color: Appearance.material.myOnSurface
                            text: WaybarLyric.cleanMusicTitle(WaybarLyric.lyrics.info.title) || "Untitled"
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
                        color: Appearance.material.myOutline
                        text: WaybarLyric.lyrics.info.artist || "Untitled"
                        elide: Text.ElideRight
                        animateChange: true
                        animationDistanceX: 6
                        animationDistanceY: 0
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
                        implicitWidth: 250
                        implicitHeight: sliderLoader.implicitHeight

                        Loader {
                            id: sliderLoader
                            anchors.fill: parent
                            sourceComponent: StyledSlider {
                                wavy: WaybarLyric.lyrics.info.status == "Playing"
                                configuration: StyledSlider.Configuration.Wavy
                                highlightColor: Appearance.material.myPrimary
                                handleColor: Appearance.material.myPrimary
                                trackColor: Appearance.material.myOnPrimaryFixedVariant
                                value: WaybarLyric.lyrics.percentage / 100
                                onMoved: WaybarLyric.setPositionPerc(value * 100)
                            }
                        }
                    }
                }
            }

            PlayerLyric {}
        }
    }
}
