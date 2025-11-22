import qs.modules.common
import qs.modules.osd
import qs.modules.bar
import qs.modules.player
import qs.modules.dock
import qs.modules.netspeed

import QtQuick
import Quickshell

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
        active: Toggle.netspeed
        component: Netspeed {}
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
