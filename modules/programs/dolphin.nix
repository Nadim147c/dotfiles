{
  delib,
  func,
  host,
  pkgs,
  ...
}:
let
  application-menu = pkgs.runCommandLocal "xdg-application-menu" { } ''
    mkdir -p $out/etc/xdg/menus/
    ln -s ${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu $out/etc/xdg/menus/applications.menu
  '';
in
delib.module {
  name = "programs.dolphin";
  options = delib.singleEnableOption host.guiFeatured;
  home.ifEnabled = {
    home.packages = with pkgs.kdePackages; [
      application-menu
      dolphin
      ffmpegthumbs
      kdegraphics-thumbnailers
      kio-admin
      kio-extras
      qtsvg
    ];

    wayland.windowManager.hyprland.settings = {
      "$files" = func.wrapUWSM "${pkgs.kdePackages.dolphin}/bin/dolphin";
    };

    xdg.configFile."dolphinrc".text = ''
      [UiSettings]
      ColorScheme=Rong
    '';
  };
}
