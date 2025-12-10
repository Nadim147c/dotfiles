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
    property real borderRadius: Appearance.round.huge

    property list<QtObject> wallpapers: []
    property int index: 1

    function down() {
        index = Math.max(index - 1, 0);
    }
    function up() {
        index = Math.min(index + 1, wallpapers.length - 1);
    }

    property color bg: Appearance.material.myBackground
    Behavior on bg {
        ColorAnimation {
            duration: Appearance.time.quick
        }
    }

    Component {
        id: wallpaperData
        QtObject {
            property string preview: ""
            property string filename: ""
            property string bg: ""
        }
    }

    Process {
        id: wallpaperFinder
        running: true
        command: ["wallpaper-list.sh"]
        stdout: SplitParser {
            onRead: data => {
                const wallpapers = JSON.parse(data);

                const qtWallpapers = [];

                for (const wallpaper of wallpapers) {
                    const obj = wallpaperData.createObject(scope, {
                        preview: wallpaper.preview,
                        filename: wallpaper.filename
                    });
                    qtWallpapers.push(obj);
                }

                scope.wallpapers = qtWallpapers;
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

                property bool scrollable: true

                Timer {
                    id: timer
                    interval: 200
                    repeat: false
                    onRunningChanged: content.scrollable = !running
                    onTriggered: content.scrollable = true
                }

                Row {
                    id: row
                    width: 600 + (Appearance.space.big * 2)

                    height: 200
                    spacing: Appearance.space.big

                    Repeater {
                        model: scope.wallpapers

                        WallpaperImage {
                            required property var modelData

                            preview: modelData.preview
                            filename: modelData.filename

                            current: index === scope.index
                            neighbor: Math.abs(scope.index - index) === 1 || index === 2 && scope.index === 0
                            secondNeighbor: Math.abs(scope.index - index) === 2
                            onScroll: down => {
                                if (!content.scrollable)
                                    return;

                                timer.start();

                                if (down) {
                                    scope.down();
                                } else {
                                    scope.up();
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
