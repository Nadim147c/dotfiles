{
    delib,
    host,
    lib,
    pkgs,
    ...
}:
delib.module {
    name = "programs.qbittorrent";
    options = delib.singleEnableOption (host.isDesktop && host.guiFeatured);
    home.ifEnabled = {
        home.packages = with pkgs; [qbittorrent];
        wayland.windowManager.hyprland.settings.exec-once = [(lib.getExe pkgs.qbittorrent)];
    };
}
