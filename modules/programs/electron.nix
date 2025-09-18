{
    delib,
    host,
    ...
}:
delib.module {
    name = "programs.electron";

    options = delib.singleEnableOption host.isDesktop;

    home.ifEnabled.xdg.configFile = let
        electronWayland = ''
            --enable-features=WaylandWindowDecorations
            --ozone-platform-hint=auto
        '';
    in {
        "electron-flags.conf".text = electronWayland;
        "equibop-flags.conf".text = electronWayland;
        "spotify-flags.conf".text = electronWayland;
    };
}
