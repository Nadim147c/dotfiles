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
  options =
    with delib;
    moduleOptions {
      enable = boolOption host.guiFeatured;
      openASAR = boolOption true;
      tts = boolOption false;
      mod = enumOption [ "vencord" "equicord" "moonlight" ] "equicord";
    };

  home.ifEnabled =
    { cfg, ... }:
    let
      inherit (lib) getExe;
      modOptions = {
        vencord = "Vencord";
        equicord = "Equicord";
        moonlight = "Moonlight";
      };
      modName = modOptions.${cfg.mod};
      discord = pkgs.discord.override {
        withOpenASAR = cfg.openASAR;
        withTTS = cfg.tts;
        "with${modName}" = true;
      };
    in
    {
      home.packages = [ discord ];

      programs.rong.settings.links."midnight-discord.css" = [
        "${xdg.configHome}/${modName}/settings/quickCss.css"
      ];

      wayland.windowManager.hyprland.settings = {
        "$discord" = "${getExe pkgs.uwsm} app -- ${getExe discord}";
      };

      xdg.mimeApps =
        let
          mime."x-scheme-handler/discord" = [ "discord.desktop" ];
        in
        {
          associations.added = mime;
          defaultApplications = mime;
        };
    };
}
