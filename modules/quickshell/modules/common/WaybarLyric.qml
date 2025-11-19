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
        property int lineIndex: 0
        property QtObject info: infoSchema
        property list<QtObject> context: []
    }

    function cleanMusicTitle(title) {
        if (!title)
            return "";
        // Brackets
        title = title.replace(/^ *\([^)]*\) */g, " "); // Round brackets
        title = title.replace(/^ *\[[^\]]*\] */g, " "); // Square brackets
        title = title.replace(/^ *\{[^\}]*\} */g, " "); // Curly brackets
        // Japenis brackets
        title = title.replace(/^ *【[^】]*】/, ""); // Touhou
        title = title.replace(/^ *《[^》]*》/, ""); // ??
        title = title.replace(/^ *「[^」]*」/, ""); // OP/ED thingie
        title = title.replace(/^ *『[^』]*』/, ""); // OP/ED thingie

        return title.trim();
    }

    function setPositionPerc(pos) {
        root.lyrics.info.position = (pos * root.lyrics.info.length) / 100;
        return Quickshell.execDetached(["waybar-lyric", "position", `${pos}%`]);
    }
    function setPosition(pos) {
        root.lyrics.info.position = pos;
        return Quickshell.execDetached(["waybar-lyric", "position", `${pos}`]);
    }

    function playpause(pos) {
        return Quickshell.execDetached(["waybar-lyric", "play-pause"]);
    }

    function next(pos) {
        return Quickshell.execDetached(["waybar-lyric", "next"]);
    }

    function previous(pos) {
        return Quickshell.execDetached(["waybar-lyric", "previous"]);
    }

    Component.onCompleted: {
        // full rebuild of context only when track changes
        for (let i = 0; i < lyricsObj.context?.length; i++) {
            if (lyricsObj.context[i].time > lyricsObj.info.position) {
                break;
            }
            lyricsObj.lineIndex = i;
        }
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
                        playing: "play_arrow",
                        paused: "pause",
                        lyric: "lyrics",
                        music: "music_note",
                        no_lyric: "mic_off",
                        getting: "downloading"
                    };
                    lyricsObj.icon = icons[parsed.alt] ?? "";

                    const oldID = infoSchema.id;

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

                    if (oldID !== info.id || lyricsObj.context.length != parsed.context.length) {
                        const ctx = [];
                        for (const c of parsed.context ?? []) {
                            const obj = contextComponent.createObject(root, {
                                line: c.line ?? "",
                                time: c.time ?? 0
                            });
                            ctx.push(obj);
                        }
                        lyricsObj.context = ctx;
                    }

                    // full rebuild of context only when track changes
                    for (let i = 0; i < parsed.context?.length; i++) {
                        if (parsed.context[i].time > info.position) {
                            break;
                        }
                        lyricsObj.lineIndex = i;
                    }
                } catch (e) {
                    console.error("Failed to parse JSON:", e);
                }
            }
        }
    }
}
