pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris

Singleton {
    id: root

    property list<QtObject> lines: []
    property int lineIndex: 0
    property int position: 0

    property string playerName: ""
    onPlayerNameChanged: {
        player = Mpris.players.values.filter(p => p.dbusName == playerName)[0];
    }

    property MprisPlayer player
    Timer {
        running: root.isPlaying
        interval: 1000
        repeat: true
        onTriggered: root.player.positionChanged()
    }

    property bool isPlaying: true

    property string text: ""
    property string title: ""
    property string artist: ""
    property string album: ""
    property string alt: ""
    property string icon: ""
    property string trackID: ""

    property string coverUrl: ""
    onCoverUrlChanged: downloadCover.exec(["download-cover.sh", coverUrl])

    property string cover: ""
    onCoverChanged: coverColors.exec(["rong", "image", "--dry-run", "--json", cover])

    Process {
        id: downloadCover
        running: false
        stdout: SplitParser {
            onRead: data => {
                if (!data || data.length === 0)
                    return;
                root.cover = data.toString().trim();
            }
        }
    }

    Process {
        id: coverColors
        running: false
        stdout: SplitParser {
            onRead: data => {
                if (!data || data.length === 0)
                    return;
                Appearance.applyPlayerColors(data.toString());
            }
        }
    }

    Component {
        id: linesComponent
        QtObject {
            property string line: ""
            property real time: 0
        }
    }

    // function setPositionPerc(pos) {
    //     root.lyrics.info.position = (pos * root.lyrics.info.length) / 100;
    //     return Quickshell.execDetached(["waybar-lyric", "position", `${pos}%`]);
    // }
    function setPosition(pos) {
        return Quickshell.execDetached(["waybar-lyric", "position", `${pos}`]);
    }

    Component.onCompleted: {
        root.player = Mpris.players.values.filter(p => p.dbusName == playerName)[0];
        // full rebuild of lines only when track changes
        for (let i = 0; i < root.lines?.length; i++) {
            if (root.lines[i].time > root.position) {
                break;
            }
            root.lineIndex = i;
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
                    root.text = parsed.text ?? "";
                    root.alt = parsed.alt ?? "";

                    const icons = {
                        playing: "play_arrow",
                        paused: "pause",
                        lyric: "lyrics",
                        music: "music_note",
                        no_lyric: "mic_off",
                        getting: "downloading"
                    };
                    root.icon = icons[parsed.alt] ?? "";

                    const oldID = root.trackID;

                    const info = parsed.info ?? {};
                    root.playerName = info.player ?? "";
                    root.trackID = info.id ?? "";
                    root.artist = info.artist ?? "";
                    root.title = info.title ?? "";
                    root.album = info.album ?? "";
                    root.position = info.position ?? "";
                    root.coverUrl = info.cover ?? "";
                    root.isPlaying = (info.status === "Playing");

                    if (oldID !== info.id || root.lines.length != parsed.lines.length) {
                        const lines = [];
                        for (const c of parsed.lines ?? []) {
                            const obj = linesComponent.createObject(root, {
                                line: c.line ?? "",
                                time: c.time ?? 0
                            });
                            lines.push(obj);
                        }
                        root.lines = lines;
                    }

                    // full rebuild of lines only when track changes
                    for (let i = 0; i < parsed.lines?.length; i++) {
                        if (parsed.lines[i].time > info.position) {
                            break;
                        }
                        root.lineIndex = i;
                    }
                } catch (e) {
                    console.error("Failed to parse JSON:", e);
                }
            }
        }
    }
}
