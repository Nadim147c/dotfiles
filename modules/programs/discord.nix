{
  delib,
  func,
  host,
  lib,
  pkgs,
  xdg,
  ...
}:
let
  inherit (func) wrapUWSM genMimes;
  inherit (lib) toSentenceCase;
in
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
      modName = toSentenceCase cfg.mod;
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
        "$discord" = wrapUWSM discord;
      };

      xdg.mimeApps = genMimes "discord.desktop" [ "x-scheme-handler/discord" ];
    };
}
