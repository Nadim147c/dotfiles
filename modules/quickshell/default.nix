{
    delib,
    home,
    host,
    inputs,
    lib,
    pkgs,
    ...
}:
delib.module {
    name = "programs.quickshell";

    options = delib.singleEnableOption host.devFeatured;

    home.ifEnabled = let
        localBin = "${home.home.homeDirectory}/.local/bin/waybar-lyric";
        system = pkgs.stdenv.hostPlatform.system;
        flakeBin = lib.getExe inputs.waybar-lyric.packages.${system}.default;
        waybar-lyric = pkgs.writeShellScriptBin "waybar-lyric" ''
            if [ -f "${localBin}" ]; then
                exec -a "$0" "${localBin}" $@
            else
                exec -a "$0" "${flakeBin}" $@
            fi
        '';
    in {
        home.packages = with pkgs; [
            kdePackages.qtdeclarative
            kdePackages.qt5compat
            kdePackages.qtmultimedia
            kdePackages.qtimageformats
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
