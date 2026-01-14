{
  delib,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) unique;
in
delib.module {
  name = "font";

  options =
    with delib;
    moduleOptions {
      enable = boolOption true;
      sans = strOption "Roboto Flex";
      serif = strOption "Roboto Serif";
      mono = strOption "JetBrainsMono Nerd Font";
      size = intOption 10;
    };

  home.ifEnabled =
    { cfg, ... }:
    {
      home.packages = with pkgs; [
        electroharmonix
        fontconfig
        material-symbols
        nerd-fonts.jetbrains-mono
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        twemoji-color-font
        noto-fonts-color-emoji
        roboto
        roboto-flex
        roboto-mono
        roboto-serif
        roboto-slab
        rubik
        (google-fonts.override {
          fonts = [
            "Gabarito"
            "Space Grotesk"
          ];
        })
      ];

      fonts.fontconfig = {
        enable = true;
        antialiasing = true;
        hinting = "slight";
        defaultFonts = {
          sansSerif = unique [
            cfg.sans
            "Rubik"
            "Roboto"
            "Noto Sans"
            "Noto Sans Bengali"
          ];

          monospace = unique [
            cfg.mono
            "JetBrainsMono Nerd Font"
            "Roboto Mono"
            "monospace"
          ];

          serif = unique [
            cfg.serif
            "Roboto Serif"
            "Noto Serif"
            "Noto Serif Bengali"
          ];

          emoji = [
            "Twitter Color Emoji"
            "Noto Color Emoji"
            "Twemoji"
          ];
        };
      };
    };
}
