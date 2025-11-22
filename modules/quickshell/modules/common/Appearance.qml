pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property QtObject material  // default empty object
    property QtObject player  // default empty object
    property QtObject font  // default empty object
    property QtObject round  // default empty object
    property QtObject space  // default empty object
    property QtObject time  // default empty object
    property QtObject animation  // default empty object
    property QtObject animationCurves  // default empty object

    round: QtObject {
        property double huge: 30
        property double larger: 20
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
        property double huge: 30
        property double larger: 20
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
        property QtObject family: QtObject {
            property string main: "Roboto Flex"
            property string numbers: "Rubik"
            property string title: "Gabarito"
            property string iconMaterial: "Material Symbols Rounded"
            property string iconNerd: "JetBrains Mono NF"
            property string monospace: "JetBrains Mono NF"
            property string reading: "Readex Pro"
            property string expressive: "Space Grotesk"
        }
        property QtObject variableAxes: QtObject {
            // Roboto Flex is customized to feel geometric, unserious yet not overly kiddy
            property var main: ({
                    // Uppercase height (Raised from 712 to be more distinguishable from lowercase)
                    "YTUC": 716,
                    // Figure (numbers) height (Lowered from 738 to match uppercase)
                    "YTFI": 716,
                    // Ascender height (Lowered from 750 to match uppercase)
                    "YTAS": 716,
                    // Lowercase height (Lowered from 514 to be more distinguishable from uppercase)
                    "YTLC": 490,
                    // Counter width (Raised from 468 to be less condensed, less serious)
                    "XTRA": 488,
                    // Width (Space out a tiny bit for readability)
                    "wdth": 105,
                    // Grade (Increased so the 6 and 9 don't look weak)
                    "GRAD": 175,
                    // Weight (Lowered to compensate for increased grade)
                    "wght": 300
                })
            // Rubik simply needs regular weight to override that of the main font where necessary
            property var numbers: ({
                    "wght": 400
                })
            // Slightly bold weight for title
            property var title: ({
                    // "YTUC": 716, // Uppercase height (Raised from 712 to be more distinguishable from lowercase)
                    // "YTFI": 716, // Figure (numbers) height (Lowered from 738 to match uppercase)
                    // "YTAS": 716, // Ascender height (Lowered from 750 to match uppercase)
                    // "YTLC": 490, // Lowercase height (Lowered from 514 to be more distinguishable from uppercase)
                    // "XTRA": 490, // Counter width (Raised from 468 to be less condensed, less serious)
                    // "wdth": 110, // Width (Space out a tiny bit for readability)
                    // "GRAD": 150, // Grade (Increased so the 6 and 9 don't look weak)
                    "wght": 900 // Weight (Lowered to compensate for increased grade)
                })
        }
        property QtObject pixelSize: QtObject {
            property int smallest: 10
            property int smaller: 12
            property int smallie: 13
            property int small: 15
            property int normal: 16
            property int large: 17
            property int larger: 19
            property int huge: 22
            property int hugeass: 23
            property int title: huge
        }
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

    player: QtObject {
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

    function applyPlayerColors(fileContent) {
        const json = JSON.parse(fileContent);
        for (let i = 0; i < json.colors.length; i++) {
            const color = json.colors[i];
            root.player["my" + color.name.pascal] = color.value.hex_rgb;
        }
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

    animationCurves: QtObject {
        readonly property list<real> expressiveFastSpatial: [0.42, 1.67, 0.21, 0.90, 1, 1] // Default, 350ms
        readonly property list<real> expressiveDefaultSpatial: [0.38, 1.21, 0.22, 1.00, 1, 1] // Default, 500ms
        readonly property list<real> expressiveSlowSpatial: [0.39, 1.29, 0.35, 0.98, 1, 1] // Default, 650ms
        readonly property list<real> expressiveEffects: [0.34, 0.80, 0.34, 1.00, 1, 1] // Default, 200ms
        readonly property list<real> emphasized: [0.05, 0, 2 / 15, 0.06, 1 / 6, 0.4, 5 / 24, 0.82, 0.25, 1, 1, 1]
        readonly property list<real> emphasizedFirstHalf: [0.05, 0, 2 / 15, 0.06, 1 / 6, 0.4, 5 / 24, 0.82]
        readonly property list<real> emphasizedLastHalf: [5 / 24, 0.82, 0.25, 1, 1, 1]
        readonly property list<real> emphasizedAccel: [0.3, 0, 0.8, 0.15, 1, 1]
        readonly property list<real> emphasizedDecel: [0.05, 0.7, 0.1, 1, 1, 1]
        readonly property list<real> standard: [0.2, 0, 0, 1, 1, 1]
        readonly property list<real> standardAccel: [0.3, 0, 1, 1, 1, 1]
        readonly property list<real> standardDecel: [0, 0, 0, 1, 1, 1]
        readonly property real expressiveFastSpatialDuration: 350
        readonly property real expressiveDefaultSpatialDuration: 500
        readonly property real expressiveSlowSpatialDuration: 650
        readonly property real expressiveEffectsDuration: 200
    }

    animation: QtObject {
        property QtObject elementMove: QtObject {
            property int duration: animationCurves.expressiveDefaultSpatialDuration
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.expressiveDefaultSpatial
            property int velocity: 650
            property Component numberAnimation: Component {
                NumberAnimation {
                    duration: root.animation.elementMove.duration
                    easing.type: root.animation.elementMove.type
                    easing.bezierCurve: root.animation.elementMove.bezierCurve
                }
            }
        }

        property QtObject elementMoveEnter: QtObject {
            property int duration: 400
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.emphasizedDecel
            property int velocity: 650
            property Component numberAnimation: Component {
                NumberAnimation {
                    duration: root.animation.elementMoveEnter.duration
                    easing.type: root.animation.elementMoveEnter.type
                    easing.bezierCurve: root.animation.elementMoveEnter.bezierCurve
                }
            }
        }

        property QtObject elementMoveExit: QtObject {
            property int duration: 200
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.emphasizedAccel
            property int velocity: 650
            property Component numberAnimation: Component {
                NumberAnimation {
                    duration: root.animation.elementMoveExit.duration
                    easing.type: root.animation.elementMoveExit.type
                    easing.bezierCurve: root.animation.elementMoveExit.bezierCurve
                }
            }
        }

        property QtObject elementMoveFast: QtObject {
            property int duration: animationCurves.expressiveEffectsDuration
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.expressiveEffects
            property int velocity: 850
            property Component colorAnimation: Component {
                ColorAnimation {
                    duration: root.animation.elementMoveFast.duration
                    easing.type: root.animation.elementMoveFast.type
                    easing.bezierCurve: root.animation.elementMoveFast.bezierCurve
                }
            }
            property Component numberAnimation: Component {
                NumberAnimation {
                    duration: root.animation.elementMoveFast.duration
                    easing.type: root.animation.elementMoveFast.type
                    easing.bezierCurve: root.animation.elementMoveFast.bezierCurve
                }
            }
        }

        property QtObject elementResize: QtObject {
            property int duration: 300
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.emphasized
            property int velocity: 650
            property Component numberAnimation: Component {
                NumberAnimation {
                    duration: root.animation.elementResize.duration
                    easing.type: root.animation.elementResize.type
                    easing.bezierCurve: root.animation.elementResize.bezierCurve
                }
            }
        }

        property QtObject clickBounce: QtObject {
            property int duration: 400
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.expressiveDefaultSpatial
            property int velocity: 850
            property Component numberAnimation: Component {
                NumberAnimation {
                    duration: root.animation.clickBounce.duration
                    easing.type: root.animation.clickBounce.type
                    easing.bezierCurve: root.animation.clickBounce.bezierCurve
                }
            }
        }

        property QtObject scroll: QtObject {
            property int duration: 200
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.standardDecel
        }

        property QtObject menuDecel: QtObject {
            property int duration: 350
            property int type: Easing.OutExpo
        }
    }
}
