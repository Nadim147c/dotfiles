import qs.modules.common

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.SystemTray

Rectangle {
    implicitHeight: parent.height
    implicitWidth: row.width + (Appearance.space.big * 2)
    radius: Appearance.round.large
    color: Appearance.material.mySurfaceVariant
    bottomLeftRadius: Appearance.round.medium
    topLeftRadius: Appearance.round.medium

    RowLayout {
        id: row
        x: Appearance.space.big
        anchors.verticalCenter: parent.verticalCenter
        spacing: 8

        Repeater {
            model: SystemTray.items

            BarTrayIcon {
                id: icon
                size: 16

                ToolTip {
                    id: tooltip
                    popupType: Popup.Native
                    y: icon.size * 2
                    delay: 500

                    contentItem: Text {
                        text: tooltip.text
                        color: Appearance.material.myOnBackground
                    }

                    background: Rectangle {
                        color: Appearance.material.myBackground
                        radius: Appearance.round.big
                    }
                }

                QsMenuAnchor {
                    id: menuAnchor
                    anchor {
                        item: icon
                        margins.top: 30
                        edges: Edges.Top | Edges.Right
                        gravity: Edges.Bottom
                    }
                    menu: icon.modelData.menu
                }

                MouseArea {
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    hoverEnabled: true
                    anchors.fill: parent

                    onClicked: mouse => {
                        switch (mouse.button) {
                        case Qt.LeftButton:
                            icon.modelData.activate();
                        case Qt.RightButton:
                            menuAnchor.open();
                        }
                    }

                    onEntered: {
                        if (icon.modelData.tooltipTitle === "")
                            return;

                        tooltip.show(icon.modelData.tooltipTitle);
                    }

                    onExited: tooltip.hide()
                }
            }
        }
    }
}
