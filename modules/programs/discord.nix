{
  delib,
  func,
  host,
  xdg,
  ...
}:
let
  inherit (func) wrapUWSM genMimes;
in
delib.module {
  name = "programs.discord";

  options = delib.singleEnableOption host.guiFeatured;

  home.ifEnabled = {
    services.flatpak = {
      packages = [ "io.github.milkshiift.GoofCord" ];
      overrides."io.github.milkshiift.GoofCord" = {
        Context.filesystems = [
          "xdg-config/goofcord"
        ];
      };
    };
    programs.rong.settings.links."midnight-discord.css" = [
      "${xdg.configHome}/goofcord/GoofCord/assets/theme.css"
    ];

    wayland.windowManager.hyprland.settings = {
      "$discord" = wrapUWSM "flatpak run io.github.milkshiift.GoofCord";
    };

    xdg.mimeApps = genMimes "discord.desktop" [ "x-scheme-handler/discord" ];
  };
}
