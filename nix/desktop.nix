{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    noto-fonts-color-emoji
  ];

  fonts.fontconfig.enable = true;
  fonts.fontconfig.defaultFonts = {
    emoji = ["Noto Font Emoji"];
    monospace = ["JetbrainsMono Nerd Font"];
    sansSerif = ["Noto Font"];
    serif = ["Noto Font Serif"];
  };

  gtk = {
    enable = true;
    font = {
      name = "Noto Font";
      package = pkgs.noto-fonts;
    };

    theme = {
      name = "adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt6;
    };
  };

  home.pointerCursor = {
    hyprcursor.enable = true;
    gtk.enable = true;
    x11.enable = true;
    name = "Volantes Cursors";
    package = pkgs.volantes-cursors;
  };

  home.file = {
    ".config/mpv".source = ../config/mpv;
    ".config/hypr".source = ../config/hypr;
    ".config/waybar".source = ../config/waybar;
    ".config/swaync".source = ../config/swaync;
    ".config/wlogout".source = ../config/wlogout;
    ".config/matugen".source = ../config/matugen;
    ".config/brave-flags.conf".source = ../config/brave-flags.conf;
  };
}
