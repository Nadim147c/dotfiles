{
  delib,
  lib,
  ...
}:
let
  inherit (lib) getExe;
in
delib.module {
  name = "programs.hyprland";

  home.ifEnabled =
    { cfg, ... }:
    {
      wayland.windowManager.hyprland.settings.bind = [
        ", PRINT, exec, ${getExe cfg.pkgs.screenshot}"
        "$mainMod, PRINT, exec, ${getExe cfg.pkgs.screenshot} screen"
      ];
    };
}
