import qs.modules.end4
import qs.modules.common

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell.Widgets
import Quickshell.Services.SystemTray

Item {
    id: root

    required property SystemTrayItem modelData

    property int size: 24

    width: size
    height: size

    function materialNameFromIcon(icon) {
        const staticNames = {
            "blueman-tray": "bluetooth",
            "blueman-disabled": "bluetooth_disabled",
            "blueman-active": "bluetooth_connected",
            "nm-no-connection": "signal_disconnected"
        };

        const parts = icon.split("/");
        const iconName = parts[parts.length - 1];

        if (iconName.startsWith("nm-stage")) {
            return "pending";
        }

        // --- Wi-Fi signal handling ---
        if (iconName.startsWith("nm-signal-")) {
            const signal = parseInt(iconName.substring("nm-signal-".length), 10);
            if (isNaN(signal))
                return "signal_wifi_bad";
            const signals = ["wifi_1_bar", "wifi_2_bar", "android_wifi_3_bar", "android_wifi_4_bar"];
            const index = Math.min(signals.length - 1, Math.floor(signal / 100 * signals.length));
            return signals[index];
        }

        return staticNames[iconName] || "";
    }

    function nerdSymbolFromIcon(icon) {
        const nerds = {
            "nm-device-wired": "󰈀",
            "kdeconnectindicatordark": "",
            "kdeconnectindicatorlight": ""
        };
        const parts = icon.split("/");
        const iconName = parts[parts.length - 1];
        const name = nerds[iconName];
        if (name) {
            return name;
        }

        const tooltips = {
            "Discord": "",
            "GoofCord": "",
            "OBS Studio": ""
        };

        const tooltipName = root.modelData.tooltipTitle;

        if (!name && tooltips[tooltipName]) {
            return tooltips[tooltipName];
        }

        return "";
    }

    property string materialName: materialNameFromIcon(modelData.icon)
    property string nerdSymbol: nerdSymbolFromIcon(modelData.icon)

    MaterialSymbol {
        id: materialIcon
        anchors.centerIn: parent
        visible: root.materialName !== ""

        text: root.materialName
        font.pixelSize: Appearance.font.pixelSize.larger
        color: Appearance.material.myOnSurfaceVariant
    }

    MaterialSymbol {
        id: nerdIcon
        anchors.centerIn: parent
        visible: root.nerdSymbol !== ""
        text: root.nerdSymbol
        font.pixelSize: Appearance.font.pixelSize.large
        font.family: Appearance.font.family.iconNerd
        color: Appearance.material.myOnSurfaceVariant
    }

    Loader {
        active: root.materialName === "" && root.nerdSymbol === ""
        sourceComponent: IconImage {
            id: fallbackIcon
            implicitSize: root.size

            source: {
                console.log(root.modelData.title, root.modelData.icon, "doesn't have any text icon");
                return root.modelData.icon;
            }
            smooth: true
            layer.enabled: true
            layer.effect: MultiEffect {
                contrast: 0.2
                brightness: 0
                saturation: -1
            }
        }
    }
}
