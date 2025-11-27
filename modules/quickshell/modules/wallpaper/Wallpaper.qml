import qs.modules.common

import QtQuick
import QtQuick.Shapes
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Widgets

Scope {
    id: scope
    property real borderRadius: Appearance.round.larger

    property list<QtObject> wallpapers: []
    property int index: 1

    property color bg: Appearance.material.mySurface

    Component {
        id: wallpaperData
        QtObject {
            property string preview: ""
            property string filename: ""
            property string primary: ""
            property string fg: ""
            property string bg: ""
        }
    }

    Process {
        id: wallpaperFinder
        running: true
        command: ["wallpaper-list.sh"]
        stdout: SplitParser {
            onRead: data => {
                const wallpaperInfo = JSON.parse(data);

                const obj = wallpaperData.createObject(scope, {
                    preview: wallpaperInfo.preview,
                    filename: wallpaperInfo.filename,
                    primary: wallpaperInfo.primary,
                    fg: wallpaperInfo.fg,
                    bg: wallpaperInfo.bg
                });

                scope.wallpapers = scope.wallpapers.concat([obj]);
            }
        }
    }

    PanelWindow {
        id: root

        anchors.bottom: true
        margins.bottom: 0

        implicitWidth: body.width + (scope.borderRadius * 2)
        implicitHeight: body.height

        WlrLayershell.namespace: "quickshell:wallpaper"
        aboveWindows: true
        exclusiveZone: 0
        color: "transparent"

        mask: Region {
            item: body
        }

        HyprlandFocusGrab {
            windows: [root]
            active: Toggle.wallpaper
            onCleared: Toggle.wallpaper = false
        }

        Shape {
            anchors.fill: parent
            preferredRendererType: Shape.CurveRenderer

            ShapePath {
                strokeWidth: 0
                fillColor: scope.bg
                startX: 0
                startY: root.height
                PathArc {
                    x: scope.borderRadius
                    y: root.height - scope.borderRadius
                    radiusX: scope.borderRadius
                    radiusY: scope.borderRadius
                    direction: PathArc.Counterclockwise
                }
                PathLine {
                    x: root.width - scope.borderRadius
                    y: root.height - scope.borderRadius
                }
                PathArc {
                    x: root.width
                    y: root.height
                    radiusX: scope.borderRadius
                    radiusY: scope.borderRadius
                    direction: PathArc.Counterclockwise
                }
            }
        }

        Rectangle {
            id: body
            x: scope.borderRadius
            implicitHeight: content.height + (Appearance.space.big * 2)
            implicitWidth: content.width + (Appearance.space.big * 2)
            radius: scope.borderRadius
            color: scope.bg

            ClippingRectangle {
                id: content
                x: Appearance.space.big
                y: Appearance.space.big
                implicitHeight: row.height
                implicitWidth: row.width
                radius: Appearance.round.medium
                color: "transparent"

                Row {
                    id: row
                    width: 600 + (Appearance.space.big * 2)

                    height: 200
                    spacing: Appearance.space.big

                    Repeater {
                        model: 1 + scope.wallpapers.length     // one extra item at the front

                        Item {
                            id: wallpaper

                            required property int index

                            property bool active: index == scope.index
                            onActiveChanged: {
                                if (active && scope.wallpapers[realIndex]) {
                                    scope.bg = scope.wallpapers[realIndex].bg;
                                }
                            }

                            // Shift real wallpaper indexes by 1
                            readonly property int realIndex: index - 1

                            property bool isFake: realIndex < 0

                            width: {
                                if (realIndex === scope.index)
                                    return 300;

                                if (Math.abs(realIndex - scope.index) === 1)
                                    return 150;

                                return 0;
                            }

                            height: parent.height

                            Behavior on width {
                                NumberAnimation {
                                    duration: 200
                                    easing.type: Easing.InOutQuad
                                }
                            }

                            // Wheel interaction only if not fake item
                            MouseArea {
                                anchors.fill: parent
                                enabled: !isFake
                                onWheel: wheel => {
                                    if (wheel.angleDelta.y > 0)
                                        scope.index = Math.max(0, scope.index - 1);
                                    else
                                        scope.index = Math.min(scope.wallpapers.length - 1, scope.index + 1);

                                    wheel.accepted = true;
                                }
                                onClicked: {
                                    if (scope.wallpapers[wallpaper.realIndex]) {
                                        console.log(["wallpaper.sh", scope.wallpapers[wallpaper.realIndex].filename]);
                                        Quickshell.execDetached(["wallpaper.sh", scope.wallpapers[wallpaper.realIndex].filename]);
                                    }
                                }
                            }

                            // Only show an image if NOT fake
                            ClippingRectangle {
                                anchors.fill: parent
                                radius: Appearance.round.medium
                                visible: !isFake

                                Image {
                                    anchors.fill: parent
                                    fillMode: Image.PreserveAspectCrop
                                    source: !isFake ? scope.wallpapers[realIndex].preview : ""
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
