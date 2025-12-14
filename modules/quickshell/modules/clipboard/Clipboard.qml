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

    implicitWidth: body.width
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
        Quickshell.execDetached(["yankd", "set", `${id}`]);
        Toggle.clipboard = false;
    }

    onQueryChanged: {
        tempClipboard = [];
        cliphist.exec(["yankd", "search", query]);
    }

    Component {
        id: clipComponent
        QtObject {
            property string id: ""
            property string mime: ""
            property string preview: ""
        }
    }

    Process {
        id: cliphist
        running: true
        onRunningChanged: {
            if (running)
                return;
            if (root.tempClipboard.length) {
                root.clipboard = root.tempClipboard;
                root.index = 0;
            }
        }
        command: ["yankd", "search", root.query]
        stdout: SplitParser {
            onRead: data => {
                const line = data.toString().trim();
                if (!line)
                    return;

                const tab = line.indexOf("\t");
                if (tab === -1)
                    return;

                // split into left = "8573-text", right = "index"
                const id = line.slice(0, tab);
                const next = line.slice(tab + 1);

                const tab2 = next.indexOf("\t");
                if (tab2 === -1)
                    return;

                const mime = next.slice(0, tab2);
                const preview = next.slice(tab2 + 1);

                // create object from Component id: clip
                const obj = clipComponent.createObject(root);
                obj.id = id;
                obj.preview = preview;
                obj.mime = mime;

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

    Rectangle {
        id: body
        implicitHeight: content.height + (Appearance.space.big * 2)
        implicitWidth: content.width + (Appearance.space.big * 2)
        radius: root.borderRadius
        color: root.bg

        ColumnLayout {
            id: content
            x: Appearance.space.big
            y: Appearance.space.big
            width: 450

            Item {
                id: inputArea
                implicitHeight: 35
                implicitWidth: content.width
                StyledDropShadow {
                    target: inputClip
                    anchors.fill: parent
                }

                ClippingRectangle {
                    id: inputClip
                    anchors.fill: parent
                    radius: (Appearance.round.large + Appearance.round.big) / 2
                    color: "transparent"

                    property color bg: Appearance.material.mySurfaceVariant

                    RowLayout {
                        id: inputRow
                        spacing: Appearance.space.tiny
                        height: parent.height
                        Rectangle {
                            color: inputClip.bg
                            implicitHeight: parent.height
                            implicitWidth: content.width - (parent.height + inputRow.spacing)
                            radius: Appearance.round.little

                            StyledTextInput {
                                anchors.verticalCenter: parent.verticalCenter
                                x: Appearance.space.medium
                                width: parent.width - (x * 2)
                                color: Appearance.material.myOnSurface
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

                        Button {
                            implicitHeight: parent.height
                            implicitWidth: parent.height
                            background: Rectangle {
                                radius: Appearance.round.little
                                color: closeMouse.containsMouse ? Appearance.material.myPrimary : Appearance.material.mySurfaceVariant
                            }
                            contentItem: Item {
                                MaterialSymbol {
                                    anchors.centerIn: parent
                                    text: "close"
                                    iconSize: Appearance.font.pixelSize.huge
                                    color: closeMouse.containsMouse ? Appearance.material.myOnPrimary : Appearance.material.myOnSurfaceVariant
                                }
                            }
                            MouseArea {
                                id: closeMouse
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                                hoverEnabled: true
                            }
                        }
                    }
                }
            }

            ClippingRectangle {
                radius: Appearance.round.medium
                implicitHeight: 300
                implicitWidth: parent.width
                color: "transparent"

                ScrollView {
                    id: scrollview
                    anchors.fill: parent

                    ScrollBar.vertical: ScrollBar {
                        id: scrollbar
                        policy: ScrollBar.AlwaysOff
                        Behavior on position {
                            animation: Appearance.animation.elementMove.numberAnimation.createObject(this)
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
                                height: clip.modelData.mime.startsWith("image/") ? image.height : text.height

                                radius: Appearance.round.medium
                                color: Appearance.material.myBackground

                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        root.index = clip.index;
                                        root.select();
                                    }
                                }

                                ClipImage {
                                    id: image
                                    mime: clip.modelData.mime
                                    content: clip.modelData.preview
                                    width: parent.width
                                }

                                ClipText {
                                    id: text
                                    mime: clip.modelData.mime
                                    content: clip.modelData.preview
                                    x: Appearance.space.medium
                                    width: parent.width - (Appearance.space.medium * 2)
                                }

                                Rectangle {
                                    anchors.fill: parent
                                    radius: clip.radius
                                    color: "transparent"
                                    visible: clip.selected
                                    opacity: visible ? 1 : 0
                                    Behavior on opacity {
                                        animation: Appearance.animation.elementMoveEnter.numberAnimation.createObject(this)
                                    }
                                    border {
                                        width: 2
                                        color: Appearance.material.myOutline
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
