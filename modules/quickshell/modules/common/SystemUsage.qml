pragma Singleton

// This code has been taken from
// https://github.com/caelestia-dots/shell/blob/main/services/SystemUsage.qml
// released under GPL-3.0

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property real cpuPerc
    property real cpuTemp
    readonly property string gpuType: autoGpuType
    property string autoGpuType: "NONE"
    property real gpuPerc
    property real gpuTemp
    property real memUsed
    property real memTotal
    readonly property real memPerc: memTotal > 0 ? memUsed / memTotal : 0
    property real storageUsed
    property real storageTotal
    property real storagePerc: storageTotal > 0 ? storageUsed / storageTotal : 0

    property real lastCpuIdle
    property real lastCpuTotal

    property real netUp: 0
    property real netDown: 0
    property real netTotal: 0
    property string netInterface
    property string netUpString
    property string netDownString
    property string netTotalString

    property int refCount

    function formatKib(kib: real): string {
        const mib = 1024;
        const gib = 1024 ** 2;
        const tib = 1024 ** 3;

        let value = kib;
        let unit = "KiB";

        if (kib >= tib) {
            value = kib / tib;
            unit = "TiB";
        } else if (kib >= gib) {
            value = kib / gib;
            unit = "GiB";
        } else if (kib >= mib) {
            value = kib / mib;
            unit = "MiB";
        }

        // Try to keep the number part within ~4 visible characters
        let str;
        if (value >= 1000) {
            str = Math.round(value).toString(); // e.g. "1024"
        } else if (value >= 100) {
            str = value.toFixed(0);             // "128"
        } else if (value >= 10) {
            str = value.toFixed(1);             // "12.3"
        } else if (value >= 1) {
            str = value.toFixed(2);             // "1.23"
        } else {
            str = value.toFixed(3);             // "0.123"
        }

        // Remove trailing ".0" or ".00"
        str = str.replace(/\.0+$|(\.\d*[1-9])0+$/, "$1");

        // Pad the numeric field to fixed width (right aligned)
        const padded = str.padStart(4, "0");

        // Return aligned number + unit
        return `${padded} ${unit}`;
    }

    Timer {
        id: timer
        running: true
        interval: 3000
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            stat.reload();
            meminfo.reload();
            storage.running = true;
            gpuUsage.running = true;
        }
    }

    Process {
        id: net
        running: true
        command: ["netspeed"] // src/netspeed
        stdout: SplitParser {
            onRead: data => {
                const netData = JSON.parse(data);
                for (const key in netData) {
                    const keyName = "net" + (key[0].toUpperCase()) + key.substring(1);
                    root[keyName] = netData[key];
                }
            }
        }
    }

    FileView {
        id: stat

        path: "/proc/stat"
        onLoaded: {
            const data = text().match(/^cpu\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)/);
            if (data) {
                const stats = data.slice(1).map(n => parseInt(n, 10));
                const total = stats.reduce((a, b) => a + b, 0);
                const idle = stats[3] + (stats[4] ?? 0);

                const totalDiff = total - root.lastCpuTotal;
                const idleDiff = idle - root.lastCpuIdle;
                root.cpuPerc = totalDiff > 0 ? (1 - idleDiff / totalDiff) : 0;

                root.lastCpuTotal = total;
                root.lastCpuIdle = idle;
            }
        }
    }

    FileView {
        id: meminfo

        path: "/proc/meminfo"
        onLoaded: {
            const data = text();
            root.memTotal = parseInt(data.match(/MemTotal: *(\d+)/)[1], 10) || 1;
            root.memUsed = (root.memTotal - parseInt(data.match(/MemAvailable: *(\d+)/)[1], 10)) || 0;
        }
    }

    Process {
        id: storage

        command: ["sh", "-c", "df | grep '^/dev/' | awk '{print $1, $3, $4}'"]
        stdout: StdioCollector {
            onStreamFinished: {
                const deviceMap = new Map();

                for (const line of text.trim().split("\n")) {
                    if (line.trim() === "")
                        continue;

                    const parts = line.trim().split(/\s+/);
                    if (parts.length >= 3) {
                        const device = parts[0];
                        const used = parseInt(parts[1], 10) || 0;
                        const avail = parseInt(parts[2], 10) || 0;

                        // Only keep the entry with the largest total space for each device
                        if (!deviceMap.has(device) || (used + avail) > (deviceMap.get(device).used + deviceMap.get(device).avail)) {
                            deviceMap.set(device, {
                                used: used,
                                avail: avail
                            });
                        }
                    }
                }

                let totalUsed = 0;
                let totalAvail = 0;

                for (const [device, stats] of deviceMap) {
                    totalUsed += stats.used;
                    totalAvail += stats.avail;
                }

                root.storageUsed = totalUsed;
                root.storageTotal = totalUsed + totalAvail;
            }
        }
    }

    Process {
        id: gpuTypeCheck

        running: root.gpuType
        command: ["sh", "-c", "if command -v nvidia-smi &>/dev/null && nvidia-smi -L &>/dev/null; then echo NVIDIA; elif ls /sys/class/drm/card*/device/gpu_busy_percent 2>/dev/null | grep -q .; then echo GENERIC; else echo NONE; fi"]
        stdout: StdioCollector {
            onStreamFinished: root.autoGpuType = text.trim()
        }
    }

    Process {
        id: gpuUsage

        command: root.gpuType === "GENERIC" ? ["sh", "-c", "cat /sys/class/drm/card*/device/gpu_busy_percent"] : root.gpuType === "NVIDIA" ? ["nvidia-smi", "--query-gpu=utilization.gpu,temperature.gpu", "--format=csv,noheader,nounits"] : ["echo"]
        stdout: StdioCollector {
            onStreamFinished: {
                if (root.gpuType === "GENERIC") {
                    const percs = text.trim().split("\n");
                    const sum = percs.reduce((acc, d) => acc + parseInt(d, 10), 0);
                    root.gpuPerc = sum / percs.length / 100;
                } else if (root.gpuType === "NVIDIA") {
                    const [usage, temp] = text.trim().split(",");
                    root.gpuPerc = parseInt(usage, 10) / 100;
                    root.gpuTemp = parseInt(temp, 10);
                } else {
                    root.gpuPerc = 0;
                    root.gpuTemp = 0;
                }
            }
        }
    }
}
