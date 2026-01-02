{
  delib,
  pkgs,
  host,
  xdg,
  func,
  lib,
  ...
}:
let
  inherit (lib) mapAttrsToList;
in
delib.module {
  name = "programs.hyprland";

  options = delib.singleEnableOption host.guiFeatured;

  home.ifEnabled =
    { myconfig, ... }:
    {
      wayland.windowManager.hyprland = {
        enable = true;
        systemd.enable = false;
        settings.monitor =
          let
            s = toString;
            # name,size@refresh-rate,position,scale
            format = display: with display; "${s width}x${s height}@${s refreshRate},${s x}x${s y},${s scale}";
            mkMonitor = name: display: "${name},${if display.enable then format display else "disable"}";
          in
          mapAttrsToList mkMonitor myconfig.displays;
      };

      home.packages = with pkgs; [
        hyprcursor
        playerctl
        wl-clipboard
      ];
      services.hyprpolkitagent.enable = true;

      programs.rong.settings.themes = func.mkList {
        target = "hyprland.conf";
        links = "${xdg.configHome}/hypr/colors.conf";
        cmds = "hyprctl reload";
      };
    };

  nixos.ifEnabled = {
    programs.hyprland.withUWSM = true;
    programs.hyprland.enable = true;
    environment.variables = {
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
      XDG_MENU_PREFIX = "arch-";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_DESKTOP = "Hyprland";
    };
  };
}
