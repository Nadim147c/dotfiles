{
    delib,
    host,
    pkgs,
    xdg,
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

        programs.rong.settings.installs = {
            "quickshell.json" = "${xdg.stateHome}/quickshell/colors.json";
        };
        programs.quickshell = {
            enable = true;
            systemd.enable = true;
        };

        wayland.windowManager.hyprland.settings.bind = [
            "$mainMod, V, global, quickshell:toggle-clipboard"
        ];
    };
}
