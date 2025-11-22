import QtQuick
import Quickshell.Io

Item {
    id: record

    // ----- External API -----
    function startRecording() {
        slurp.running = true;
    }
    Component.onCompleted: {
        record.startRecording();
    }

    Process {
        id: slurp
        running: false
        command: ["slurp"]
        stdout: StdioCollector {
            onStreamFinished: console.log(`line read: ${this.text}`)
        }
        stderr: StdioCollector {
            onStreamFinished: console.log(`line read: ${this.text}`)
        }
    }

    // ----- State -----
    property bool recording: false
    property real startTime: 0
    property string timestamp: ""

    // ------------------------------------------------------------
    // 2. wl-screenrec -g "<region>"
    // ------------------------------------------------------------
    Process {
        id: screenrec
        running: false

        onStarted: {
            record.recording = true;
            record.startTime = Date.now();

            recordPanel.visible = true;
            timer.running = true;
        }

        onExited: {
            record.recording = false;
            timer.running = false;
            recordPanel.visible = false;
        }
    }

    // Called by slurp
    function startScreenrec(region) {
        screenrec.exec({
            command: ["wl-screenrec", "-g", region, "-f", "/tmp/recording.mp4"]
        });
    }

    // ------------------------------------------------------------
    // 3. Timer logic (your code)
    // ------------------------------------------------------------
    Timer {
        id: timer
        interval: 93
        repeat: true

        onTriggered: {
            const now = Date.now();
            const diff = now - record.startTime;

            const d = new Date(diff - (60 * 60 * 6 * 1000));
            var full = Qt.formatDateTime(d, "hh:mm:ss.zzz");
            var parts = full.split(":");

            if (parts[0] === "00")
                parts.shift();
            if (parts.length === 2 && parts[0] === "00")
                parts.shift();

            record.timestamp = parts.join(":").slice(0, -1);
        }
    }

    // ------------------------------------------------------------
    // 4. Timer panel UI
    // ------------------------------------------------------------
    RecordPanel {
        id: recordPanel
        visible: false
        timestamp: record.timestamp

        onClickStop: {
            screenrec.signal(3); // SIGKILL
        }
    }
}
