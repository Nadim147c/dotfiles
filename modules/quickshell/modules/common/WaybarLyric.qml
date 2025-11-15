pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    QtObject {
        id: infoSchema
        property string player: ""
        property string id: ""
        property string artist: ""
        property string title: ""
        property string album: ""
        property string cover: ""
        property int volume: 0
        property bool shuffle: false
        property string status: ""
        property real position: 0
        property real length: 0
        property string url: ""
    }

    Component {
        id: contextComponent
        QtObject {
            property string line: ""
            property bool active: false
            property real time: 0
        }
    }

    property QtObject lyrics: QtObject {
        id: lyricsObj
        property string text: ""
        property list<string> className: []
        property string alt: ""
        property string icon: ""
        property string tooltip: ""
        property int percentage: 0
        property QtObject info: infoSchema
        property list<QtObject> context: []
    }

    Process {
        id: commandProcess
        running: true
        command: ["waybar-lyric", "--detailed"]

        stdout: SplitParser {
            onRead: data => {
                try {
                    if (!data || data.length === 0)
                        return;

                    const jsonText = data.toString();
                    const parsed = JSON.parse(jsonText);

                    // Fill lyrics object field-by-field
                    lyricsObj.text = parsed.text ?? "";
                    lyricsObj.className = parsed.class ?? [];
                    lyricsObj.alt = parsed.alt ?? "";
                    lyricsObj.tooltip = parsed.tooltip ?? "";
                    lyricsObj.percentage = parsed.percentage ?? 0;

                    const icons = {
                        playing: "",
                        paused: "",
                        lyric: "",
                        music: "󰝚",
                        no_lyric: "",
                        getting: ""
                    };
                    lyricsObj.icon = icons[parsed.alt] ?? "";

                    const info = parsed.info ?? {};
                    infoSchema.player = info.player ?? "";
                    infoSchema.id = info.id ?? "";
                    infoSchema.artist = info.artist ?? "";
                    infoSchema.title = info.title ?? "";
                    infoSchema.album = info.album ?? "";
                    infoSchema.cover = info.cover ?? "";
                    infoSchema.volume = info.volume ?? 0;
                    infoSchema.shuffle = info.shuffle ?? false;
                    infoSchema.status = info.status ?? "";
                    infoSchema.position = info.position ?? 0;
                    infoSchema.length = info.length ?? 0;
                    infoSchema.url = info.url ?? "";

                    // Rebuild context list
                    const ctx = [];
                    for (const c of parsed.context ?? []) {
                        const obj = contextComponent.createObject(root, {
                            line: c.line ?? "",
                            active: c.active ?? false,
                            time: c.time ?? 0
                        });
                        ctx.push(obj);
                    }
                    lyricsObj.context = ctx;
                } catch (e) {
                    console.error("Failed to parse JSON:", e);
                }
            }
        }
    }
}
