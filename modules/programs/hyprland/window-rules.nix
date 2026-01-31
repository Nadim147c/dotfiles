{
  delib,
  lib,
  func,
  ...
}:
let
  inherit (lib) toList;
  inherit (func) cut;
in
delib.module {
  name = "programs.hyprland";

  home.ifEnabled =
    let

      mergeMatches =
        matches:
        matches
        |> map (x: cut " " x)
        |> map (x: {
          "${x.prefix}" = x.content;
        })
        |> builtins.zipAttrsWith (_: v: v)
        |> lib.mapAttrsToList (name: value: "match:${name} ^(${lib.join "|" value})$");

      /*
        createWindowRule name rules matches.

        :: Exmaple
          createWindowRule "float" {float= true;} [ "match:class mpv" ]
        ::
      */
      createWindowRule =
        name: rules: matches:
        let
          tag = "${builtins.hashString "md5" (builtins.toJSON rules)}-${name}";
          identifier = {
            name = tag;
            "match:tag" = tag;
          };
          matchRules = mergeMatches matches |> map (x: "tag +${tag},${x}");
        in
        [ (rules // identifier) ] ++ matchRules;

      opaqueWindow = createWindowRule "opaque" { opacity = "1 1 1"; };
      terminalWindow = createWindowRule "terminal" { opacity = "0.95 0.90"; };
      browserWindow = createWindowRule "browser" { workspace = "2 silent"; };
      discordWindow = createWindowRule "discord" {
        workspace = "3 silent";
        # no_screen_share = true;
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
        opacity = "1 1 ";
        size = "monitor_w/4 monitor_h/4";
        move = "monitor_w-window_w-10 monitor_h-window_h-10";
        rounding = 7.5;
      };
    in
    {
      wayland.windowManager.hyprland.settings.windowrule =
        floatingWindow [
          "class org.kde.dolphin"
          "class org.gnome.Nautilus"
          "class thunar"
        ]
        ++ fixedWindow [
          "class .?blueman-manager(-wrapped)?"
          "class hyprland-dialog"
          "class kvantummanager"
          "class mpv"
          "class nwg-look"
          "class org.freedesktop.impl.portal.desktop.*"
          "class org.gnome.Loupe"
          "class org.kde.kdeconnect.app"
          "class org.pulseaudio.pavucontrol"
          "class qt5ct"
          "class qt6ct"
          "class tvp-git-helper"
          "class vlc"
          "class xdg-desktop-portal-gtk"
          "class xdg-desktop-portal-hyprland"
          "title Choose Files?.*"
          "title Confirm to replace files"
          "title File Operation Progress"
          "title Open( Files?)?.*"
          "title Save As.*"
          "title Send File — Dolphin.*"
        ]
        ++ browserWindow [
          "class zen"
          "class zen-beta"
          "class brave-browser"
        ]
        ++ discordWindow [
          "class discord"
          "class vesktop"
          "class equibop"
          "class WebCord"
          "class ArmCord"
          "class goofcord"
        ]
        ++ musicWindow [
          "class [Ss]potify"
          "initial_title Spotify (Free|Premium)"
          "class com.github.th_ch.youtube_music"
        ]
        ++ pipWindow [ "title [Pp]icture[ -][Ii]n[ -][Pp]icture" ]
        ++ opaqueWindow [
          "title [Pp]icture[ -][Ii]n[ -][Pp]icture"
          "class mpv"
        ]
        ++ terminalWindow [
          "class kitty"
          "class org.wezfurlong.wezterm"
          "class com.mitchellh.ghostty"
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
