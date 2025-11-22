import qs.modules.common
import qs.modules.osd
import qs.modules.bar
import qs.modules.player
import qs.modules.dock

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import Quickshell.Widgets

ShellRoot {
    property bool shouldShowOsd: false

    Component.onCompleted: {
        Appearance.reloadTheme();
    }

    LazyLoader {
        active: true
        component: VolumeOSD {}
    }
    LazyLoader {
        active: true
        component: Bar {}
    }
    LazyLoader {
        active: Toggle.player
        component: Player {}
    }
    LazyLoader {
        active: Toggle.dock
        component: Dock {}
    }
    LazyLoader {
        active: true
        component: DockSpawner {}
    }
}
