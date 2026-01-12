{
  delib,
  func,
  host,
  inputs,
  pkgs,
  ...
}:
delib.module {
  name = "programs.browsers";

  options.programs.browsers = with delib; {
    enable = boolOption host.guiFeatured;
    default = enumOption [ "brave" "tor" "zen" ] "zen";
  };

  home.ifEnabled =
    { cfg, ... }:
    let
      desktops = {
        brave = "brave.desktop";
        zen = "zen-beta.desktop";
        tor = "torbrowser.desktop";
      };

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

      xdg.mimeApps = func.genMimes desktops.${cfg.default} [
        "application/pdf"
        "text/html"
        "x-scheme-handler/about"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
        "x-scheme-handler/unknown"
      ];
    };
}
