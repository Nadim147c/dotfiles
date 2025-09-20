{
    delib,
    host,
    pkgs,
    ...
}:
delib.module {
    name = "programs.mpvpaper";
    options = delib.singleEnableOption host.isDesktop;
    home.ifEnabled = {
        home.packages = with pkgs; [mpvpaper mpvpaper-daemon];
        wayland.windowManager.hyprland.settings.exec-once = [
            "${pkgs.waypaper}/bin/waypaper --restore"
            "sleep 15 && ${pkgs.uwsm}/bin/uwsm app -- ${pkgs.mpvpaper-daemon}/bin/mpvpaper-daemon"
        ];
    };
}
