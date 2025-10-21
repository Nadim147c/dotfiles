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
        home.packages = with pkgs; [
            mpvpaper
            mpvpaper-daemon
            wallpaper-sh
        ];
        wayland.windowManager.hyprland.settings.exec-once = [
            "${pkgs.uwsm}/bin/uwsm app -- ${pkgs.mpvpaper-daemon}/bin/mpvpaper-daemon"
        ];
    };
}
