pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property list<QtObject> clipboard: []
    property string query: ""

    Component {
        id: clipComponent
        QtObject {
            property string id: ""
            property string mime: ""
            property string preview: ""
        }
    }

    function search(text) {
        root.query = text;
        yankd.exec(["yankd", "search", text]);
    }

    function set(id) {
        yankd.exec(["yankd", "search", ""]);
        Quickshell.execDetached(["yankd", "set", `${id}`]);
    }

    function deleteItem(id) {
        Quickshell.execDetached(["yankd", "delete", `${id}`]);
        timer.start(); // reload the query after delete
    }

    Timer {
        id: timer
        interval: 100
        running: true
        repeat: false
        onTriggered: {
            yankd.exec(["yankd", "search", root.query]);
        }
    }

    Process {
        id: yankd
        running: true
        command: ["yankd", "search", ""]
        stdout: StdioCollector {
            id: output
            onStreamFinished: data => {
                const clipboard = [];
                for (const l of output.text.split("\n")) {
                    const line = l.trim();
                    if (!line)
                        continue;

                    const tab = line.indexOf("\t");
                    if (tab === -1)
                        continue;

                    // split into left = "8573-text", right = "index"
                    const id = line.slice(0, tab);
                    const next = line.slice(tab + 1);

                    const tab2 = next.indexOf("\t");
                    if (tab2 === -1)
                        continue;

                    const mime = next.slice(0, tab2);
                    const preview = next.slice(tab2 + 1);

                    // create object from Component id: clip
                    const obj = clipComponent.createObject(root);
                    obj.id = id;
                    obj.preview = preview;
                    obj.mime = mime;
                    clipboard.push(obj);
                }
                if (clipboard.length) {
                    root.clipboard = clipboard;
                }
            }
        }
    }
}
