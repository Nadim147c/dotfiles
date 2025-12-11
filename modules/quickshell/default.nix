{
    delib,
    host,
    pkgs,
    ...
}:
delib.module {
    name = "programs.quickshell";

    options = delib.singleEnableOption host.guiFeatured;

    home.ifEnabled = {
        home.packages = with pkgs; [
            kdePackages.qt5compat
            kdePackages.qtdeclarative
            kdePackages.qtimageformats
            kdePackages.qtmultimedia
        ];

        xdg.configFile."quickshell".source = ./.;

        programs.quickshell = {
            enable = true;
            systemd.enable = true;
        };

        wayland.windowManager.hyprland.settings.bind = [
            "$mainMod, V, global, quickshell:toggle-clipboard"
        ];
    };
}
