{
  delib,
  func,
  pkgs,
  xdg,
  ...
}:
delib.module {
  name = "programs.mpv";

  options =
    with delib;
    moduleOptions {
      enable = boolOption true;
      videoOutputDriver = strOption "gpu";
    };

  home.ifEnabled =
    { cfg, ... }:
    {
      programs.mpv = {
        enable = true;
        package = pkgs.symlinkJoin {
          name = "mpv-wrapped";
          paths =
            let
              scripts = with pkgs.mpvScripts; [
                modernx
                mpris
                quality-menu
                sponsorblock
                thumbfast
                videoclip
              ];
              mpv = pkgs.mpv.override { inherit scripts; };
            in
            [ mpv ];
          nativeBuildInputs = [ pkgs.makeWrapper ];
          postBuild = ''
            wrapProgram $out/bin/mpv \
              --add-flags "--vo=${cfg.videoOutputDriver}"
          '';
        };
        scriptOpts.videoclip = {
          video_folder_path = xdg.userDirs.videos;
          audio_folder_path = xdg.userDirs.music;
        };
        config = {
          osc = false;
          save-position-on-quit = true;
          keep-open = true;
          sub-fix-timing = true;
          blend-subtitles = true;
          sub-auto = "fuzzy";
          slang = "en,eng,enUS,en-US";
          user-agent = "Mozilla/5.0";
          # msg-level=all=debug
          script-opts = "ytdl_hook-ytdl_path=yt-dlp,ytdl_hook-try_ytdl_first=yes";
          ytdl-raw-options = "sub-lang=\"en,eng,enUS,en-US\",write-sub=,write-auto-sub=,yes-playlist=,concurrent-fragments=4";
        };
        bindings = {
          "ctrl+f" = "script-binding quality_menu/video_formats_toggle";
          "." = "cycle-values video-aspect \"16:9\" \"4:3\" \"2.35:1\" \"-1\"";
          "s" = "cycle-values sub-pos 100 60";
          "ENTER" = "cycle-values fullscreen yes no";
          "KP_ENTER" = "cycle-values fullscreen yes no";
          "MOUSE_BTN1" = "cycle-values fullscreen yes no";
          "MOUSE_BTN0" = "cycle pause";
          "CTRL+UP" = "add sub-font-size 2";
          "CTRL+DOWN" = "add sub-font-size -2";
          "UP" = "add volume 2";
          "DOWN" = "add volume -2";
          "KP4" = "playlist-prev";
          "KP6" = "playlist-next";
          "<" = "add sub-delay -0.1";
          ">" = "add sub-delay +0.1";
          "*" = "set speed 1";
          "+" = "add speed +0.1";
          "KP_ADD" = "add speed +0.1";
          "-" = "add speed -0.1";
          "KP_SUBTRACT" = "add speed -0.1";
        };
      };

      xdg.mimeApps = func.genMimes "mpv.desktop" [
        # Audio
        "audio/aac"
        "audio/mp4"
        "audio/mpeg"
        "audio/mpegurl"
        "audio/ogg"
        "audio/vnd.rn-realaudio"
        "audio/vorbis"
        "audio/x-flac"
        "audio/x-mp3"
        "audio/x-mpegurl"
        "audio/x-ms-wma"
        "audio/x-musepack"
        "audio/x-oggflac"
        "audio/x-pn-realaudio"
        "audio/x-scpls"
        "audio/x-vorbis"
        "audio/x-vorbis+ogg"
        "audio/x-wav"

        # Video
        "video/3gp"
        "video/3gpp"
        "video/3gpp2"
        "video/avi"
        "video/divx"
        "video/dv"
        "video/fli"
        "video/flv"
        "video/mp2t"
        "video/mp4"
        "video/mp4v-es"
        "video/mpeg"
        "video/msvideo"
        "video/ogg"
        "video/quicktime"
        "video/vnd.divx"
        "video/vnd.mpegurl"
        "video/vnd.rn-realvideo"
        "video/webm"
        "video/x-avi"
        "video/x-flv"
        "video/x-m4v"
        "video/x-matroska"
        "video/x-mpeg2"
        "video/x-ms-asf"
        "video/x-ms-wmv"
        "video/x-ms-wmx"
        "video/x-msvideo"
        "video/x-ogm"
        "video/x-ogm+ogg"
        "video/x-theora"
        "video/x-theora+ogg"
      ];
    };
}
