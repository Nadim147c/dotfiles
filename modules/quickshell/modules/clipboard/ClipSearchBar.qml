import qs.modules.end4
import qs.modules.common

import QtQuick
import QtQuick.Layouts

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

    RowLayout {
        id: inputRow
        spacing: Appearance.space.tiny
        anchors.fill: parent

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Appearance.material.mySurfaceVariant
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

        Rectangle {
            implicitHeight: parent.height
            implicitWidth: height
            radius: Appearance.round.big
            topLeftRadius: Appearance.round.little
            bottomLeftRadius: Appearance.round.little
            color: closeMouse.containsMouse ? Appearance.material.myPrimary : Appearance.material.mySurfaceVariant
            MaterialSymbol {
                anchors.centerIn: parent
                text: "close"
                iconSize: Appearance.font.pixelSize.huge
                color: closeMouse.containsMouse ? Appearance.material.myOnPrimary : Appearance.material.myOnSurfaceVariant
            }

            MouseArea {
                id: closeMouse
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                hoverEnabled: true
                onClicked: root.close()
            }
        }
    }
}
