{delib, ...}:
delib.module {
    name = "programs.hyprland";

    home.ifEnabled.wayland.windowManager.hyprland.settings.layerrule = [
        "blur,logout_dialog"
        "blur,launcher"
        "ignorezero,launcher"
        "blur,rofi"
        "ignorezero,gtk-layer-shell"
        "ignorezero,wofi"
        "blur,wofi"
        "animation slide 0.4, wofi"
    ];

    home.ifEnabled.wayland.windowManager.hyprland.settings.windowrule = [
        # Transparency
        "opacity 0.98 0.95 1,class:kitty|org.wezfurlong.wezterm|com.mitchellh.ghostty"
        "opacity 0.0 override, class:xwaylandvideobridge"
        "noanim, class:xwaylandvideobridge"
        "noinitialfocus, class:xwaylandvideobridge"
        "maxsize 1 1, class:xwaylandvideobridge"
        "noblur, class:xwaylandvideobridge"

        # Pin
        "pin,class:hyprland-dialog"

        # Terminal Image
        "tag +term-img,class:ueberzugpp.*"
        "noblur,tag:term-img"
        "noanim,tag:term-img"
        "noshadow,tag:term-img"

        # Showme the keys
        "tag +key-display,class:showmethekey-gtk"
        "float, tag:key-display"
        "opacity 1 1, tag:key-display"
        "size 600 50, tag:key-display"
        "pin, tag:key-display"
        "move 100%-w-20 100%-w-20, tag:key-display"
        "noborder, tag:key-display"

        # Calendar the keys
        "tag +calendar,class:org.gnome.Calendar"
        "float, tag:calendar"
        "opacity 1 1, tag:calendar"
        "size 360 600, tag:calendar"
        "pin, tag:calendar"
        "move 100%-w-10 40, tag:calendar"
        "noborder, tag:calendar"
        "animation fade, tag:calendar"

        # Set position for Picture in Picture mode
        "tag +pip-window, title:[Pp]icture[ -][Ii]n[ -][Pp]icture"
        "float, tag:pip-window"
        "opacity 1 1, tag:pip-window"
        "size 25% 25%, tag:pip-window"
        "pin, tag:pip-window"
        "move 100%-w-20 100%-w-20, tag:pip-window"

        # Discord and other app rules
        "tag +discord,class:discord|vesktop|equibop|WebCord|ArmCord|goofcord"
        "workspace 3 silent, tag:discord"
        "tag +noscreenshare, tag:discord"

        # Music
        "tag +music, class:[Ss]potify"
        "tag +music, initialTitle:Spotify (Free|Premium)"
        "tag +music, class:com.github.th_ch.youtube_music"
        "workspace 4 silent, tag:music"

        # Steam
        "workspace 5 silent, class:steam"

        # Clipboard
        "tag +float, class:clipboard"
        "size 80% 50%, class:clipboard"

        # Waypaper
        "tag +waypaper, class:waypaper"
        "float, tag:waypaper"
        "center, tag:waypaper"
        "pin, tag:waypaper"
        "size 830 625, tag:waypaper"

        # KDE Connect Presentation Mode
        "opacity 1, title:KDE Connect Daemon"
        "noblur, title:KDE Connect Daemon"
        "noborder, title:KDE Connect Daemon"
        "noshadow, title:KDE Connect Daemon"
        "noanim, title:KDE Connect Daemon"
        "nofocus, title:KDE Connect Daemon"
        "suppressevent fullscreen, title:KDE Connect Daemon"
        "float, title:KDE Connect Daemon"
        "pin, title:KDE Connect Daemon"
        "minsize 1366 768, title:KDE Connect Daemon"

        # Browsers
        "tag +browser,class:zen"
        "tag +browser,class:brave-browser"
        "workspace 2 silent,tag:browser"
        "suppressevent maximize, class:.*"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
        "noblur,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"

        # Small float windows
        "tag +float-small, class:vlc"
        "tag +float-small, class:mpv"
        "tag +float-small, class:xdg-desktop-portal-gtk"
        "tag +float-small, class:xdg-desktop-portal-hyprland"
        "tag +float-small, title:Send File — Dolphin, floating:0"
        "tag +float-small, class:nwg-look"
        "tag +float-small, class:org.pulseaudio.pavucontrol"

        # Update window
        "tag +update-window,class:update-window"
        "float,tag:update-window"
        "size 60% 60%,tag:update-window"
        "opacity 0.9 0.9,tag:update-window"
        "move 100%-w-20 50,tag:update-window"

        # Media float window
        "tag +float-fixed, class:kvantummanager"
        "tag +float-fixed, class:org.gnome.Loupe"

        # Large float windows
        "tag +float-large, class:org.gnome.Nautilus"
        "tag +float-large, class:org.kde.dolphin"
        "tag +float-large, class:thunar"
        "tag +float-small, class:tvp-git-helper"

        # File file-selector
        "tag +file-selector,title:Open( Files?)?.*"
        "tag +file-selector,title:Choose Files?.*"
        "tag +file-selector,title:Save As.*"
        "tag +file-selector,title:Confirm to replace files"
        "tag +file-selector,title:File Operation Progress"
        "tag +file-selector,class:org\.freedesktop\.impl\.portal\.desktop.*"
        "pin,tag:file-selector"
        "tag +float-fixed,tag:file-selector"

        # Apply window rules
        "tag +float, tag:float-small"
        "tag +float, tag:float-fixed"
        "tag +float, tag:float-large"
        "tag +center, tag:float-small"
        "tag +center, tag:float-fixed"
        "tag +center, tag:float-large"
        "size 50% 50%, tag:float-small"
        "size 70% 70%, tag:float-fixed"
        "size 80% 80%, tag:float-large"
        "float, tag:float"
        "center, tag:center"
        "noscreenshare, tag:noscreenshare"
    ];
}
