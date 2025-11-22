{
    delib,
    host,
    lib,
    pkgs,
    xdg,
    ...
}:
delib.module {
    name = "programs.discord";

    options = delib.singleEnableOption host.guiFeatured;

    home.ifEnabled = let
        discord = pkgs.equibop;
    in {
        home.packages = [discord];

        programs.rong.settings.links."midnight-discord.css" = [
            "${xdg.configHome}/equibop/settings/quickCss.css"
        ];

        wayland.windowManager.hyprland.settings = {
            "$discord" = "${lib.getExe pkgs.uwsm} app -- ${lib.getExe discord}";
        };

        xdg.mimeApps = let
            mime."x-scheme-handler/discord" = ["equibop.desktop"];
        in {
            associations.added = mime;
            defaultApplications = mime;
        };
    };
}
