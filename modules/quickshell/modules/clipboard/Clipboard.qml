import qs.modules.common
import qs.modules.widgets
import qs.modules.end4

import QtQuick
import QtQuick.Shapes
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Widgets

PanelWindow {
    id: root

    property real borderRadius: Appearance.round.larger
    property color bg: Appearance.material.mySurface

    anchors.bottom: true
    margins.bottom: 0

    implicitWidth: body.width + (borderRadius * 2)
    implicitHeight: body.height

    WlrLayershell.namespace: "quickshell:clipboard"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    aboveWindows: true
    exclusiveZone: 0
    color: "transparent"

    property list<QtObject> clipboard: []
    property list<QtObject> tempClipboard: []
    property string query: ""

    property int index: 0
    function down() {
        index = Math.min(clipboard.length - 1, index + 1);
    }
    function up() {
        index = Math.max(0, index - 1);
    }
    function select() {
        const id = clipboard[index].id;
        Quickshell.execDetached(["sh", "-c", `cliphist decode ${id} | wl-copy`]);
        Toggle.clipboard = false;
    }

    onQueryChanged: {
        tempClipboard = [];
        if (query !== "") {
            cliphist.exec(["cliphist-query", query]);
        } else {
            cliphist.exec(["cliphist-query"]);
        }
    }

    Component {
        id: clipComponent
        QtObject {
            property string id: ""
            property string mime: ""
            property string content: ""
        }
    }

    Process {
        id: cliphist
        running: true
        onRunningChanged: {
            if (running)
                return;
            if (tempClipboard.length) {
                root.clipboard = root.tempClipboard;
                root.index = 0;
            }
        }
        command: ["cliphist-query"]
        stdout: SplitParser {
            onRead: data => {
                const line = data.toString().trim();
                if (!line)
                    return;

                // find ':'
                const colon = line.indexOf(":");
                if (colon === -1)
                    return;

                // split into left = "8573-text", right = "index"
                const left = line.slice(0, colon);
                const content = line.slice(colon + 1);

                const [id, kind] = left.split("-");

                // create object from Component id: clip
                const obj = clipComponent.createObject(root);
                obj.id = id;
                obj.content = content;
                obj.mime = kind;

                root.tempClipboard.push(obj);
            }
        }
    }

    mask: Region {
        item: body
    }

    HyprlandFocusGrab {
        id: hyprland
        windows: [root]
        active: true
        onCleared: Toggle.clipboard = false
    }

    Shape {
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            strokeWidth: 0
            fillColor: root.bg
            startX: 0
            startY: root.height
            PathArc {
                x: root.borderRadius
                y: root.height - root.borderRadius
                radiusX: root.borderRadius
                radiusY: root.borderRadius
                direction: PathArc.Counterclockwise
            }
            PathLine {
                x: root.width - root.borderRadius
                y: root.height - root.borderRadius
            }
            PathArc {
                x: root.width
                y: root.height
                radiusX: root.borderRadius
                radiusY: root.borderRadius
                direction: PathArc.Counterclockwise
            }
        }
    }

    Rectangle {
        id: body
        x: root.borderRadius
        implicitHeight: content.height + (Appearance.space.big * 2)
        implicitWidth: content.width + (Appearance.space.big * 2)
        radius: root.borderRadius
        color: root.bg

        ColumnLayout {
            id: content
            x: Appearance.space.big
            y: Appearance.space.big
            width: 450

            Rectangle {
                id: textinput
                height: 40
                width: parent.width
                radius: Appearance.round.small
                color: Appearance.material.myBackground

                StyledTextInput {
                    width: parent.width - (Appearance.space.medium * 2)
                    x: Appearance.space.medium
                    anchors.verticalCenter: parent.verticalCenter
                    color: Appearance.material.myOnBackground
                    focus: hyprland.active
                    onTextChanged: root.query = text
                    onFocusChanged: hyprland.active = focus

                    Keys.onPressed: event => {
                        // Close on Esc
                        if (event.key === Qt.Key_Escape) {
                            Toggle.clipboard = false;
                            return;
                        }

                        // Ctrl+N or Down Arrow → move forward
                        if ((event.key === Qt.Key_N && event.modifiers === Qt.ControlModifier) || event.key === Qt.Key_Down || event.key === Qt.Key_Up + 0 && event.key === Qt.Key_J) {
                            root.down();
                            event.accepted = true;
                            return;
                        }

                        // Ctrl+P or Up Arrow → move backward
                        if ((event.key === Qt.Key_P && event.modifiers === Qt.ControlModifier) || event.key === Qt.Key_Up || event.key === Qt.Key_K) {
                            root.up();
                            event.accepted = true;
                            return;
                        }

                        // Enter → trigger action
                        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            root.select();
                            event.accepted = true;
                            return;
                        }
                    }
                }
            }

            ScrollView {
                id: scrollview
                implicitHeight: 300
                implicitWidth: parent.width

                ScrollBar.vertical: ScrollBar {
                    id: scrollbar
                    policy: ScrollBar.AlwaysOff
                    Behavior on position {
                        NumberAnimation {
                            duration: Appearance.time.normal
                            easing.type: Appearance?.animation.elementMoveFast.type ?? Easing.BezierSpline
                            easing.bezierCurve: Appearance?.animation.elementMoveFast.bezierCurve ?? [0.34, 0.80, 0.34, 1.00, 1, 1]
                        }
                    }
                }

                ColumnLayout {
                    id: clipColumn
                    width: parent.width
                    spacing: Appearance.space.visible
                    Repeater {
                        model: root.clipboard

                        ClippingRectangle {
                            id: clip

                            required property var modelData
                            required property int index
                            property bool selected: index === root.index

                            onSelectedChanged: {
                                if (!select)
                                    return;

                                const max = 1 - (height / clipColumn.height);
                                const pos = (y + height - scrollview.height) / clipColumn.height;
                                scrollbar.position = Math.min(max, Math.max(pos, 0));
                            }

                            implicitWidth: parent.width
                            height: clip.modelData.mime == "text" ? text.height : image.height

                            radius: Appearance.round.small
                            color: Appearance.material.myBackground
                            border {
                                width: selected ? 2 : 0
                                color: Appearance.material.myOutline

                                pixelAligned: false
                                Behavior on width {
                                    animation: Appearance.animation.elementMove.numberAnimation.createObject(this)
                                }
                            }

                            ClipImage {
                                id: image
                                mime: clip.modelData.mime
                                content: clip.modelData.content
                                width: parent.width
                            }

                            ClipText {
                                id: text
                                mime: clip.modelData.mime
                                content: clip.modelData.content
                                x: Appearance.space.medium
                                width: parent.width - (Appearance.space.medium * 2)
                            }
                        }
                    }
                }
            }
        }
    }
}
