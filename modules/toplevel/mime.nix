{
  delib,
  host,
  ...
}:
delib.module {
  name = "mime";

  options = delib.singleEnableOption host.isDesktop;

  home.ifEnabled = {
    xdg.mime.enable = true;
    xdg.mimeApps = {
      enable = true;
      associations.added = {
        "application/json" = [
          "org.kde.kwrite.desktop"
          "nvim.desktop"
        ];
        "application/x-docbook+xml" = [
          "org.kde.kwrite.desktop"
          "nvim.desktop"
        ];
        "application/x-matroska" = [ "mpv.desktop" ];
        "application/x-yaml" = [
          "org.kde.kwrite.desktop"
          "nvim.desktop"
        ];
        "text/markdown" = [
          "org.kde.kwrite.desktop"
          "nvim.desktop"
        ];
        "text/plain" = [
          "org.kde.kwrite.desktop"
          "nvim.desktop"
        ];
        "text/x-cmake" = [
          "org.kde.kwrite.desktop"
          "nvim.desktop"
        ];
        "x-scheme-handler/geo" = [ "qwant-maps-geo-handler.desktop" ];
        "x-scheme-handler/tg" = [ "org.telegram.desktop.desktop" ];
        "x-scheme-handler/tonsite" = [ "org.telegram.desktop.desktop" ];
      };

      defaultApplications = {
        "application/json" = [ "org.kde.kwrite.desktop" ];
        "application/x-docbook+xml" = [ "org.kde.kwrite.desktop" ];
        "application/x-matroska" = [ "mpv.desktop" ];
        "application/x-yaml" = [ "org.kde.kwrite.desktop" ];
        "image/jpeg" = [ "org.gnome.Loupe.desktop" ];
        "image/png" = [ "org.gnome.Loupe.desktop" ];
        "image/webp" = [ "org.gnome.Loupe.desktop" ];
        "inode/directory" = [ "org.kde.dolphin.desktop" ];
        "text/markdown" = [ "org.kde.kwrite.desktop" ];
        "text/plain" = [ "org.kde.kwrite.desktop" ];
        "text/x-cmake" = [ "org.kde.kwrite.desktop" ];
        "x-scheme-handler/geo" = [ "qwant-maps-geo-handler.desktop" ];
        "x-scheme-handler/postman" = [ "Postman.desktop" ];
        "x-scheme-handler/tg" = [ "org.telegram.desktop.desktop" ];
        "x-scheme-handler/tonsite" = [ "org.telegram.desktop.desktop" ];
      };
    };
  };
}
