pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property QtObject material  // default empty object
    property QtObject font  // default empty object
    property QtObject round  // default empty object
    property QtObject space  // default empty object
    property QtObject time  // default empty object
    property QtObject anim  // default empty object

    round: QtObject {
        property double large: 15
        property double big: 10
        property double medium: 7
        property double small: 5
        property double little: 4
        property double tiny: 3
        property double visible: 1.5
        property double none: 0
    }

    space: QtObject {
        property double large: 15
        property double big: 10
        property double medium: 7
        property double small: 5
        property double little: 4
        property double tiny: 3
        property double visible: 1.5
        property double none: 0
    }

    time: QtObject {
        property double instant: 0
        property double swift: 100
        property double quick: 250
        property double normal: 400
        property double slow: 1500
        property double lazy: 2500
        property double linger: 4000
    }

    font: QtObject {
        property string icon: "JetBrainsMono Nerd Font Propo"
        property string mono: "JetBrainsMono Nerd Font"
        property string main: "Roboto"
        property string bold: "Roboto Black"
    }

    material: QtObject {
        property string myBackground: "#141317"
        property string myColor0: "#27242F"
        property string myColor1: "#DA346B"
        property string myColor2: "#008954"
        property string myColor3: "#767D00"
        property string myColor4: "#386AFF"
        property string myColor5: "#B73DD9"
        property string myColor6: "#0081A9"
        property string myColor7: "#F3EEFD"
        property string myColor8: "#3D3A45"
        property string myColor9: "#FF85A2"
        property string myColorA: "#00C47A"
        property string myColorB: "#AAB300"
        property string myColorC: "#90A7FF"
        property string myColorD: "#E784FF"
        property string myColorE: "#00B8F0"
        property string myColorF: "#FFFFFF"
        property string myError: "#FF7B6E"
        property string myErrorContainer: "#A4020D"
        property string myErrorDim: "#DA342E"
        property string myInverseOnSurface: "#56545A"
        property string myInversePrimary: "#615A80"
        property string myInverseSurface: "#FDF8FE"
        property string myNeutralPaletteKeyColor: "#79767C"
        property string myNeutralVariantPaletteKeyColor: "#797580"
        property string myOnBackground: "#E6E1E8"
        property string myOnError: "#530003"
        property string myOnErrorContainer: "#FFAEA4"
        property string myOnPrimary: "#262042"
        property string myOnPrimaryContainer: "#E7DFFF"
        property string myOnPrimaryFixed: "#3A3357"
        property string myOnPrimaryFixedVariant: "#564F75"
        property string myOnSecondary: "#413E51"
        property string myOnSecondaryContainer: "#C2BCD4"
        property string myOnSecondaryFixed: "#393549"
        property string myOnSecondaryFixedVariant: "#565266"
        property string myOnSurface: "#FEF9FF"
        property string myOnSurfaceVariant: "#A5A1AD"
        property string myOnTertiary: "#7A5273"
        property string myOnTertiaryContainer: "#714A6A"
        property string myOnTertiaryFixed: "#664060"
        property string myOnTertiaryFixedVariant: "#855D7E"
        property string myOutline: "#85818D"
        property string myOutlineVariant: "#56525D"
        property string myPrimary: "#A69DC8"
        property string myPrimaryContainer: "#554D73"
        property string myPrimaryDim: "#A198C2"
        property string myPrimaryFixed: "#DBD1FE"
        property string myPrimaryFixedDim: "#CDC3F0"
        property string myPrimaryPaletteKeyColor: "#7A729A"
        property string myScrim: "#000000"
        property string mySecondary: "#CAC3DC"
        property string mySecondaryContainer: "#3D394C"
        property string mySecondaryDim: "#BCB5CE"
        property string mySecondaryFixed: "#DBD4ED"
        property string mySecondaryFixedDim: "#CCC6DE"
        property string mySecondaryPaletteKeyColor: "#79748A"
        property string myShadow: "#000000"
        property string mySurface: "#0F0E12"
        property string mySurfaceBright: "#2D2B34"
        property string mySurfaceContainer: "#1A1920"
        property string mySurfaceContainerHigh: "#201E26"
        property string mySurfaceContainerHighest: "#27242E"
        property string mySurfaceContainerLow: "#141319"
        property string mySurfaceContainerLowest: "#000000"
        property string mySurfaceDim: "#0F0D15"
        property string mySurfaceTint: "#CAC1ED"
        property string mySurfaceVariant: "#48454F"
        property string myTertiary: "#FFF7F9"
        property string myTertiaryContainer: "#FFE3F6"
        property string myTertiaryDim: "#FFD7F4"
        property string myTertiaryFixed: "#FFF7F9"
        property string myTertiaryFixedDim: "#FFE3F6"
        property string myTertiaryPaletteKeyColor: "#946A8C"
    }

    function reloadTheme() {
        themeFileView.reload();
    }

    function applyColors(fileContent) {
        const json = JSON.parse(fileContent);
        for (const key in json) {
            if (json.hasOwnProperty(key)) {
                root.material[key] = json[key];
            }
        }
    }

    FileView {
        id: themeFileView
        path: "/home/ephemeral/.local/state/rong/quickshell.json"
        watchChanges: true

        onFileChanged: {
            console.log("File changed, reloading...");
            themeFileView.reload();
        }
        onLoaded: {
            if (!themeFileView.loaded) {
                return;
            }
            const fileContent = themeFileView.text();
            try {
                root.applyColors(fileContent);
            } catch (e) {
                console.error("failed parse JSON: ", e, fileContent);
            }
        }
    }
}
