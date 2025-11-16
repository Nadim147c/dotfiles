{
    delib,
    edge,
    host,
    lib,
    pkgs,
    xdg,
    ...
}:
delib.module {
    name = "programs.discord";
    options = delib.moduleOptions (with delib; {
        enable = boolOption host.guiFeatured;
        openASAR = boolOption true;
        tts = boolOption false;
        mod = enumOption ["vencord" "equicord" "moonlight"] "equicord";
    });

    home.ifEnabled = {cfg, ...}: let
        modOptions = {
            vencord = "Vencord";
            equicord = "Equicord";
            moonlight = "Moonlight";
        };
        modName = modOptions.${cfg.mod};
        discord = edge.discord.override {
            withOpenASAR = cfg.openASAR;
            withTTS = cfg.tts;
            "with${modName}" = true;
        };
    in {
        home.packages = [discord];

        programs.rong.settings.links."midnight-discord.css" = [
            "${xdg.configHome}/${modName}/settings/quickCss.css"
        ];

        wayland.windowManager.hyprland.settings = {
            "$discord" = "${lib.getExe pkgs.uwsm} app -- ${discord}/bin/discord";
        };

        xdg.mimeApps = let
            mime."x-scheme-handler/discord" = ["discord.desktop"];
        in {
            associations.added = mime;
            defaultApplications = mime;
        };
    };
}
