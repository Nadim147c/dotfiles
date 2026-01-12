{
  delib,
  lib,
  ...
}:
let
  inherit (lib) toList;
in
delib.module {
  name = "programs.hyprland";

  home.ifEnabled =
    let
      /*
        createWindowRule name rules matches.

        :: Exmaple
          createWindowRule "float" {float= true;} [ "match:class mpv" ]
        ::
      */
      createWindowRule =
        name: rules: matches:
        let
          tag = "${name}-${builtins.hashString "md5" (builtins.toJSON rules)}";
          identifier = {
            name = tag;
            "match:tag" = tag;
          };
          matchRules = map (x: "tag +${tag},${x}") matches;
        in
        [ (rules // identifier) ] ++ matchRules;

      terminalWindow = createWindowRule "terminal" { opacity = "0.95 0.90"; };
      browserWindow = createWindowRule "browser" { workspace = "2 silent"; };
      discordWindow = createWindowRule "discord" {
        workspace = "3 silent";
        no_screen_share = true;
      };
      musicWindow = createWindowRule "music" { workspace = "4 silent"; };
      floatingWindow = createWindowRule "float" {
        float = true;
        center = true;
      };
      fixedWindow = createWindowRule "float" {
        float = true;
        center = true;
        size = "monitor_w*0.7 monitor_h*0.7";
      };
      pipWindow = createWindowRule "picture-in-picture" {
        float = true;
        pin = true;
        size = "monitor_w/4 monitor_h/4";
        move = "monitor_w-window_w-10 monitor_h-window_h-10";
        rounding = 7.5;
      };
    in
    {
      wayland.windowManager.hyprland.settings.windowrule =
        floatingWindow [
          "match:class org.kde.dolphin"
          "match:class org.gnome.Nautilus"
          "match:class thunar"
        ]
        ++ fixedWindow [
          "match:class .?blueman-manager(-wrapped)?"
          "match:class hyprland-dialog"
          "match:class kvantummanager"
          "match:class mpv"
          "match:class nwg-look"
          "match:class org.freedesktop.impl.portal.desktop.*"
          "match:class org.gnome.Loupe"
          "match:class org.kde.kdeconnect.app"
          "match:class org.pulseaudio.pavucontrol"
          "match:class qt5ct"
          "match:class qt6ct"
          "match:class tvp-git-helper"
          "match:class vlc"
          "match:class xdg-desktop-portal-gtk"
          "match:class xdg-desktop-portal-hyprland"
          "match:title Choose Files?.*"
          "match:title Confirm to replace files"
          "match:title File Operation Progress"
          "match:title Open( Files?)?.*"
          "match:title Save As.*"
          "match:title Send File — Dolphin.*"
        ]
        ++ browserWindow [
          "match:class zen"
          "match:class zen-beta"
          "match:class brave-browser"
        ]
        ++ discordWindow [
          "match:class discord"
          "match:class vesktop"
          "match:class equibop"
          "match:class WebCord"
          "match:class ArmCord"
          "match:class goofcord"
        ]
        ++ musicWindow [
          "match:class [Ss]potify"
          "match:initial_title Spotify (Free|Premium)"
          "match:class com.github.th_ch.youtube_music"
        ]
        ++ pipWindow [ "match:title [Pp]icture[ -][Ii]n[ -][Pp]icture" ]
        ++ terminalWindow [
          "match:class kitty"
          "match:class org.wezfurlong.wezterm"
          "match:class com.mitchellh.ghostty"
        ]
        ++ toList {
          name = "KDE Connect Daemon";
          "match:title" = "KDE Connect Daemon";
          opacity = 1;
          no_blur = true;
          border_size = 0;
          no_shadow = true;
          no_anim = true;
          no_focus = true;
          fullscreen = true;
          pin = true;
          move = "0 0";
        };
    };
}
