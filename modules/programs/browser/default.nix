{
  delib,
  func,
  host,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) toList unique;
in
delib.module {
  name = "programs.browsers";

  options.programs.browsers = with delib; {
    enable = boolOption host.guiFeatured;
    default = enumOption [ "brave" "tor" "zen" ] "brave";
  };

  home.ifEnabled =
    { cfg, ... }:
    let
      desktops = {
        brave = "brave.desktop";
        zen = "zen-beta.desktop";
        tor = "torbrowser.desktop";
      };
      desktop = (toList desktops.${cfg.default}) ++ builtins.attrValues desktops |> unique;

      packages = {
        inherit (pkgs) brave;
        tor = pkgs.tor-browser;
        zen = func.flakePackage inputs.zen-browser;
      };
      pkg = packages.${cfg.default};
    in
    {
      wayland.windowManager.hyprland.settings = {
        "$browser" = func.wrapUWSM pkg;
      };

      xdg.mimeApps = func.genMimes desktop [
        "application/pdf"
        "text/html"
        "x-scheme-handler/about"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
        "x-scheme-handler/unknown"
      ];
    };
}
