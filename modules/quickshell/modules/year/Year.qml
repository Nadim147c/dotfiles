import qs.modules.common
import qs.modules.end4
import qs.modules.end4.functions

import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

PanelWindow {
    id: root
    property real borderRadius: Appearance.round.large
    property real padding: Appearance.space.big

    property color bg: ColorUtils.transparentize(Appearance.player.myBackground, 0.15)
    Behavior on bg {
        ColorAnimation {
            duration: Appearance.time.quick
        }
    }

    anchors.bottom: true
    margins.bottom: 0

    implicitWidth: body.width + (root.borderRadius * 2)
    implicitHeight: body.height + title.height + padding

    WlrLayershell.namespace: "quickshell:year"
    aboveWindows: true
    exclusiveZone: 0
    color: "transparent"

    mask: Region {
        item: body
    }

    HyprlandFocusGrab {
        windows: [root]
        active: Toggle.year
        onCleared: Toggle.year = false
    }

    Shape {
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            strokeWidth: 0
            fillColor: root.bg

            // Start at bottom-left corner
            startX: 0
            startY: root.height

            // Bottom-left rounded corner
            PathArc {
                x: root.borderRadius
                y: root.height - root.borderRadius
                radiusX: root.borderRadius
                radiusY: root.borderRadius
                direction: PathArc.Counterclockwise
            }

            // Left vertical edge
            PathLine {
                x: root.borderRadius
                y: root.borderRadius
            }

            // Top-left rounded corner
            PathArc {
                x: root.borderRadius * 2
                y: 0
                radiusX: root.borderRadius
                radiusY: root.borderRadius
                direction: PathArc.Clockwise
            }

            // Top edge until title notch starts
            PathLine {
                x: root.borderRadius + root.padding + title.width
                y: 0
            }

            // Notch top-right corner (go down into title area)
            PathArc {
                x: root.borderRadius + root.padding * 2 + title.width
                y: root.padding
                radiusX: root.borderRadius
                radiusY: root.borderRadius
                direction: PathArc.Clockwise
            }

            // Notch vertical edge (down alongside title)
            PathLine {
                x: root.borderRadius + root.padding * 2 + title.width
                y: title.height
            }

            // Notch bottom-right corner (back out to main top edge)
            PathArc {
                x: root.borderRadius + root.padding * 3 + title.width
                y: title.height + root.padding
                radiusX: root.padding // use smaller radius
                radiusY: root.padding
                direction: PathArc.Counterclockwise
            }

            // Top edge to right corner
            PathLine {
                x: root.width - root.borderRadius * 2
                y: title.height + root.padding
            }

            // Top-right rounded corner
            PathArc {
                x: root.width - root.borderRadius
                y: title.height + root.borderRadius + root.padding
                radiusX: root.borderRadius
                radiusY: root.borderRadius
                direction: PathArc.Clockwise
            }

            // Right vertical edge
            PathLine {
                x: root.width - root.borderRadius
                y: root.height - root.borderRadius
            }

            // Bottom-right rounded corner
            PathArc {
                x: root.width
                y: root.height
                radiusX: root.borderRadius
                radiusY: root.borderRadius
                direction: PathArc.Counterclockwise
            }
        }
    }

    function init() {
        const div = 1000 * 60 * 60 * 24;

        var now = new Date();
        var year = now.getFullYear();

        var start = new Date(year, 0, 1);
        var end = new Date(year + 1, 0, 1);

        days = Math.floor((end - start) / div);
        position = Math.floor((now - start) / div);
    }
    function getDateFromDayIndex(index) {
        var now = new Date();
        var year = now.getFullYear();

        var start = new Date(year, 0, 1);
        start.setDate(start.getDate() + index);

        return start;
    }

    Component.onCompleted: init()

    StyledText {
        id: title
        text: "Year Progress"
        font {
            family: Appearance.font.family.title
            pixelSize: Appearance.font.pixelSize.large
        }
        x: root.borderRadius + root.padding
        y: root.padding
    }

    property real days: 0
    property real position: 0

    Rectangle {
        id: body
        x: root.borderRadius
        y: title.height + root.padding
        implicitHeight: content.height + (Appearance.space.big * 2)
        implicitWidth: content.width + (Appearance.space.big * 2)
        radius: root.borderRadius
        color: "transparent"
        RowLayout {
            id: content
            x: Appearance.space.big
            y: Appearance.space.big

            Repeater {
                model: Math.ceil(root.days / 7)
                ColumnLayout {
                    id: week
                    required property real modelData
                    Repeater {
                        model: 7
                        Rectangle {
                            id: day
                            required property real modelData
                            property real index: (week.modelData * 7) + modelData
                            width: 10
                            height: width
                            radius: Appearance.round.tiny
                            StyledToolTip {
                                function getOrdinal(n) {
                                    if (n % 100 >= 11 && n % 100 <= 13)
                                        return "th";
                                    switch (n % 10) {
                                    case 1:
                                        return "st";
                                    case 2:
                                        return "nd";
                                    case 3:
                                        return "rd";
                                    default:
                                        return "th";
                                    }
                                }
                                function formatPrettyDate(date) {
                                    var days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
                                    var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

                                    var dayName = days[date.getDay()];
                                    var dayNum = date.getDate();
                                    var monthName = months[date.getMonth()];
                                    var year = date.getFullYear();

                                    return dayName + ", " + dayNum + getOrdinal(dayNum) + " " + monthName + ", " + year;
                                }

                                text: formatPrettyDate(root.getDateFromDayIndex(index))
                                extraVisibleCondition: mouseArea.containsMouse
                            }
                            MouseArea {
                                id: mouseArea
                                anchors.fill: parent
                                visible: index <= root.days
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                            }
                            color: {
                                if (index < root.position) {
                                    return Appearance.material.mySecondaryContainer;
                                } else if (index === root.position) {
                                    return Appearance.material.myPrimary;
                                } else if (index <= root.days) {
                                    return Appearance.material.mySurfaceVariant;
                                } else {
                                    return "transparent";
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
