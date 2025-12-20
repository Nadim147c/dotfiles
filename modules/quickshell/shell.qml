//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma UseQApplication

import qs.modules.common
import qs.modules.osd
import qs.modules.bar
import qs.modules.player
import qs.modules.dock
import qs.modules.netspeed
import qs.modules.wallpaper
import qs.modules.logout
import qs.modules.clipboard

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
    LazyLoader {
        active: Toggle.wallpaper
        component: Wallpaper {}
    }
    LazyLoader {
        active: Toggle.logout
        component: Logout {}
    }
    LazyLoader {
        active: Toggle.clipboard
        component: Clipboard {}
    }
}
