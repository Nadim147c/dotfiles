{
    delib,
    host,
    pkgs,
    ...
}:
delib.module {
    name = "programs.quickshell";

    options = delib.singleEnableOption host.devFeatured;

    home.ifEnabled = {
        home.packages = with pkgs; [
            kdePackages.qtdeclarative
            quickshell
            waybar-lyric
        ];

        wayland.windowManager.hyprland.settings.bind = [
            "$mainMod, V, global, quickshell:toggle-clipboard"
        ];

        systemd.user.services.quickshell = {
            Unit = {
                Description = "QuickShell config";
                After = ["graphical-session.target"];
                PartOf = ["graphical-session.target"];
            };

            Install.WantedBy = ["graphical-session.target"];

            Service = {
                ExecStart = "${pkgs.quickshell}/bin/qs -p ${./.}/shell.qml";
            };
        };
    };
}
