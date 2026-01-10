{
  lib,
  delib,
  pkgs,
  host,
  ...
}:
let
  inherit (lib) mkForce mkIf;
in
delib.module {
  name = "gtk";

  options = delib.singleEnableOption host.guiFeatured;

  nixos.ifEnabled.environment.variables = {
    GTK_THEME = "adw-gtk3-dark";
    GDK_BACKEND = "wayland,x11,*";
  };

  home.ifEnabled =
    { myconfig, ... }:
    {
      xdg.configFile."gtk-4.0/gtk.css".enable = mkForce false;
      home.packages = with pkgs; [
        gtk3
        gtk4
        gtk4-layer-shell
        nwg-look
      ];

      gtk = {
        enable = true;
        iconTheme = {
          name = "Adwaita-dark";
          package = pkgs.adwaita-icon-theme;
        };

        theme = {
          name = "adw-gtk3-dark";
          package = pkgs.adw-gtk3;
        };

        font = mkIf myconfig.font.enable {
          name = myconfig.font.sans;
          size = myconfig.font.size;
        };

        gtk3.extraConfig = {
          gtk-application-prefer-dark-theme = 1;
        };

        gtk4.extraConfig = {
          gtk-application-prefer-dark-theme = 1;
        };
      };

      dconf.settings."org/gnome/desktop/interface" =
        let
          sizeStr = toString myconfig.font.size;
          fonts = mkIf myconfig.font.enable {
            font-name = "${myconfig.font.sans} ${sizeStr}";
            document-font-name = "${myconfig.font.sans} ${sizeStr}";
            monospace-font-name = "${myconfig.font.mono} ${sizeStr}";
          };
        in
        {
          icon-theme = "Adwaita-dark";
          gtk-theme = "adw-gtk3-dark";
          color-scheme = "prefer-dark";
          font-antialiasing = "rgba";
          font-hinting = "full";
        }
        // fonts;
    };
}
