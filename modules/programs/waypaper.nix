{
    delib,
    host,
    pkgs,
    ...
}:
delib.module {
    name = "programs.waypaper";

    options = delib.singleEnableOption host.isDesktop;

    home.ifEnabled.home.packages = with pkgs; [waypaper wallpaper-sh];
    home.ifEnabled.xdg.configFile."waypaper/config.ini".text = ''
        [Settings]
        language = en
        folder = ~/Pictures/Wallpapers/
        monitors = All
        post_command = ${pkgs.wallpaper-sh}/bin/wallpaper.sh \$wallpaper
        show_path_in_tooltip = True
        backend = none
        use_xdg_state = True
    '';
}
