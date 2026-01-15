import qs.modules.common

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland

PanelWindow {
    id: root

    property real borderRadius: Appearance.round.larger
    property color bg: Appearance.material.mySurface
    property real size: 450

    implicitWidth: body.width
    implicitHeight: body.height

    WlrLayershell.namespace: "quickshell:clipboard"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    aboveWindows: true
    exclusiveZone: 0
    color: "transparent"

    property list<QtObject> clipboard: []
    property string query: ""
    onQueryChanged: {
        console.log("[Clipboard] query:", query);
        cliphist.exec(["yankd", "search", "--format=json", query]);
    }

    property QtObject active: clipboard[0]

    onIndexChanged: {
        active = clipboard[index];
        listview.currentIndex = index;
    }
    onClipboardChanged: {
        active = clipboard[index];
    }

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

    Component {
        id: clipComponent
        QtObject {
            property string id: ""
            property string mime: ""
            property string preview: ""
            property string text: ""
            property string image: ""
        }
    }

    Process {
        id: cliphist
        running: true
        command: ["yankd", "search", "--format=json"]
        stderr: StdioCollector {
            id: err
            onStreamFinished: console.log(err.text)
        }
        stdout: StdioCollector {
            id: output
            function normalizeString(input) {
                if (!input)
                    return "";
                return input.replace(/\s+/g, " ").trim();
            }

            onStreamFinished: {
                const json = JSON.parse(output.text);
                const clipboard = [];
                for (const clip of json) {
                    const obj = clipComponent.createObject(root);
                    obj.id = clip.id;
                    obj.mime = clip.mime;
                    obj.text = clip.text || "";
                    obj.image = clip.blob_path || "";
                    obj.preview = normalizeString(clip.text || clip.metadata || clip.url);
                    clipboard.push(obj);
                }
                root.clipboard = clipboard;
                root.index = 0;
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

    RowLayout {
        id: body
        spacing: Appearance.space.tiny

        height: root.size

        ClipPreview {
            id: preview
            active: root.active
            borderRadius: root.borderRadius
            bg: root.bg
            implicitHeight: root.size
            implicitWidth: root.size
        }

        Rectangle {
            radius: borderRadius
            color: bg
            implicitHeight: root.size
            implicitWidth: root.size
            topLeftRadius: Appearance.space.big
            bottomLeftRadius: Appearance.space.big

            Item {
                x: Appearance.space.big
                y: Appearance.space.big
                height: parent.height - (Appearance.space.big * 2)
                width: parent.width - (Appearance.space.big * 2)

                ColumnLayout {
                    anchors.fill: parent
                    ClipSearchBar {
                        id: search
                        onSearch: q => {
                            root.query = q;
                        }
                        onMoveUp: root.up()
                        onMoveDown: root.down()
                        onSelectItem: root.select()
                        onClose: Toggle.clipboard = false
                    }
                    ClipListView {
                        id: listview
                        clipboard: root.clipboard
                        currentIndex: root.index
                        onItemSelected: root.select()
                    }
                }
            }
        }
    }
}
