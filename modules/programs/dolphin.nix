{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "programs.dolphin";
  options = delib.singleEnableOption host.guiFeatured;
  home.ifEnabled = {
    home.packages =
      with pkgs.kdePackages;
      let
        application-menu = pkgs.runCommandLocal "xdg-application-menu" { } ''
          mkdir -p $out/etc/xdg/menus/
          ln -s ${plasma-workspace}/etc/xdg/menus/plasma-applications.menu $out/etc/xdg/menus/applications.menu
        '';
      in
      [
        application-menu
        dolphin
        ffmpegthumbs
        kdegraphics-thumbnailers
        kio-admin
        kio-extras
        qtsvg
      ];

    wayland.windowManager.hyprland.settings = {
      "$files" = "${pkgs.uwsm}/bin/uwsm app -- ${pkgs.kdePackages.dolphin}/bin/dolphin";
    };

    xdg.configFile."dolphinrc".text = ''
      [KFileDialog Settings]
      Places Icons Auto-resize=false
      Places Icons Static Size=22

      [UiSettings]
      ColorScheme=Rong

      [PreviewSettings]
      Plugins=appimagethumbnail,audiothumbnail,comicbookthumbnail,cursorthumbnail,djvuthumbnail,ebookthumbnail,exrthumbnail,imagethumbnail,jpegthumbnail,kraorathumbnail,opendocumentthumbnail,svgthumbnail,windowsexethumbnail,windowsimagethumbnail,blenderthumbnail,ffmpegthumbs,gsthumbnail,mltpreview,mobithumbnail,rawthumbnail
    '';
  };
}
