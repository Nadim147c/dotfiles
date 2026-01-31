{
  delib,
  host,
  inputs,
  xdg,
  ...
}:
let
  share = xdg.dataHome;
in
delib.module {
  name = "flatpak";

  options = delib.singleEnableOption host.isDesktop;

  nixos.ifEnabled = {
    services.flatpak.enable = true;
  };

  home.always.imports = [ inputs.nix-flatpak.homeManagerModules.nix-flatpak ];
  home.ifEnabled.services.flatpak = {
    packages = [ "com.github.tchx84.Flatseal" ];
    overrides = {
      global = {
        Context.filesystems = [
          "xdg-config/fontconfig:ro"
          "xdg-config/gtk-3.0:ro"
          "xdg-config/gtk-4.0:ro"
          "xdg-data/icons:ro"
          "${share}/icons:ro"
          "xdg-data/color-schemes:ro"
          "xdg-data/fonts:ro"
          "xdg-data/nix/store:ro"
          "xdg-download"
          "xdg-public-share"
          "/nix/store:ro"
          "!xdg-videos"
          "!xdg-pictures"
          "!xdg-music"
        ];

        Environment = {
          XCURSOR_PATH = "/run/current-system/sw/share/icons:${share}/icons";
        };

        # Force Wayland by default
        Context.sockets = [
          "wayland"
          "!x11"
          "!fallback-x11"
        ];
      };
    };
  };
}
