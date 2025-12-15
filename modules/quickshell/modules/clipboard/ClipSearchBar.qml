import qs.modules.end4
import qs.modules.common

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland

Item {
    id: root

    signal search(string text)
    signal moveUp
    signal moveDown
    signal selectItem
    signal close

    height: 35
    Layout.fillWidth: true

    StyledDropShadow {
        target: inputClip
        anchors.fill: parent
    }

    ClippingRectangle {
        id: inputClip
        anchors.fill: parent
        radius: (Appearance.round.large + Appearance.round.big) / 2
        color: "transparent"

        property color bg: Appearance.material.mySurfaceVariant

        RowLayout {
            id: inputRow
            spacing: Appearance.space.tiny
            anchors.fill: parent

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: inputClip.bg
                radius: Appearance.round.little

                StyledTextInput {
                    anchors.verticalCenter: parent.verticalCenter
                    x: Appearance.space.medium
                    width: parent.width - (x * 2)
                    color: Appearance.material.myOnSurface
                    focus: true
                    onTextChanged: root.search(text)

                    Keys.onPressed: event => {
                        // Close on Esc
                        if (event.key === Qt.Key_Escape) {
                            root.close();
                            return;
                        }

                        // Ctrl+N or Down Arrow → move forward
                        if ((event.key === Qt.Key_N && event.modifiers === Qt.ControlModifier) || event.key === Qt.Key_Down || event.key === Qt.Key_J) {
                            root.moveDown();
                            event.accepted = true;
                            return;
                        }

                        // Ctrl+P or Up Arrow → move backward
                        if ((event.key === Qt.Key_P && event.modifiers === Qt.ControlModifier) || event.key === Qt.Key_Up || event.key === Qt.Key_K) {
                            root.moveUp();
                            event.accepted = true;
                            return;
                        }

                        // Enter → trigger action
                        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            root.selectItem();
                            event.accepted = true;
                            return;
                        }
                    }
                }
            }

            Button {
                Layout.preferredHeight: parent.height
                Layout.preferredWidth: parent.height

                background: Rectangle {
                    radius: Appearance.round.little
                    color: closeMouse.containsMouse ? Appearance.material.myPrimary : Appearance.material.mySurfaceVariant
                }

                contentItem: Item {
                    MaterialSymbol {
                        anchors.centerIn: parent
                        text: "close"
                        iconSize: Appearance.font.pixelSize.huge
                        color: closeMouse.containsMouse ? Appearance.material.myOnPrimary : Appearance.material.myOnSurfaceVariant
                    }
                }

                onClicked: root.close()

                MouseArea {
                    id: closeMouse
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                    hoverEnabled: true
                }
            }
        }
    }
}
