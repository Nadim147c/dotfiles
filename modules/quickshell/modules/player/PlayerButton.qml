import qs.modules.common
import qs.modules.end4

import QtQuick

GroupButton {
    id: root
    required property string iconName
    property real buttonHeight
    property real buttonWidth

    colBackground: Appearance?.player.myPrimary
    colBackgroundHover: Appearance?.player.myTertiary
    colBackgroundActive: Appearance?.player.myPrimary
    colBackgroundToggled: Appearance?.player.myTertiary
    colBackgroundToggledHover: Appearance?.player.myPrimary
    colBackgroundToggledActive: Appearance?.player.myTertiary
    colOnBackground: Appearance?.player.myOnPrimary
    colOnBackgroundHover: Appearance?.player.myOnTertiary
    colOnBackgroundActive: Appearance?.player.myOnPrimary
    colOnBackgroundToggled: Appearance?.player.myOnTertiary
    colOnBackgroundToggledHover: Appearance?.player.myOnPrimary
    colOnBackgroundToggledActive: Appearance?.player.myOnTertiary

    contentItem: Item {
        implicitHeight: root.buttonHeight
        implicitWidth: root.buttonWidth
        MaterialSymbol {
            anchors.centerIn: parent
            iconSize: Appearance.font.pixelSize.hugeass
            text: root.iconName
            color: root.fg
        }
    }
}
