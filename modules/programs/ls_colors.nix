{
  lib,
  delib,
  host,
  ...
}:
delib.module {
  name = "programs.LS_COLORS";

  options = delib.singleEnableOption host.cliFeatured;

  home.ifEnabled =
    let
      reset = "0";
      bold = "1";
      dim = "2";
      italic = "3";
      underline = "4";
      blink = "5";
      reverse = "7";
      black = "30";
      red = "31";
      green = "32";
      yellow = "33";
      blue = "34";
      magenta = "35";
      cyan = "36";
      white = "37";
      brightBlack = "90";
      brightRed = "91";
      brightGreen = "92";
      brightYellow = "93";
      brightBlue = "94";
      brightMagenta = "95";
      brightCyan = "96";
      brightWhite = "97";
      bgBlack = "40";
      bgRed = "41";
      bgGreen = "42";
      bgYellow = "43";
      bgBlue = "44";
      bgMagenta = "45";
      bgCyan = "46";
      bgWhite = "47";
      bgBrightBlack = "100";
      bgBrightRed = "101";
      bgBrightGreen = "102";
      bgBrightYellow = "103";
      bgBrightBlue = "104";
      bgBrightMagenta = "105";
      bgBrightCyan = "106";
      bgBrightWhite = "107";

      join = x: y: "${x};${y}";

      palette = {
        text = bold;
        doc = brightWhite;
        todo = brightYellow;
        license = brightCyan;
        config = cyan;
        markup = brightBlue;
        code = brightCyan;
        build = yellow;
        vcs = brightBlack;
        mediaImage = magenta;
        mediaAudio = brightMagenta;
        mediaVideo = brightRed;
        archive = red;
        executable = brightGreen;
        unimportant = join brightBlack italic;
      };

      core = {
        no = reset; # normal text
        fi = reset; # regular file
        rs = reset; # reset to normal

        di = join bold blue; # directory
        ln = join cyan bold; # symlink
        mh = brightBlue; # multi hard link
        pi = yellow; # fifo
        so = magenta; # socket
        do = brightMagenta; # door

        bd = join yellow bold; # block device
        cd = join yellow bold; # char device

        "or" = join brightRed bgBlack; # broken symlink
        mi = join brightRed bgBlack; # missing target

        su = join brightRed bold; # setuid
        sg = join brightYellow bold; # setgid
        ca = join brightGreen bold; # capability

        tw = join black bgBrightGreen; # sticky + other writable
        ow = join blue bgBrightGreen; # other writable
        st = join white bgBlue; # sticky

        ex = join brightGreen bold; # executable
      };

      files = {
        "${palette.doc}" = [
          "README"
          "README.md"
          "README.txt"
          "CHANGELOG"
          "CHANGELOG.md"
          "CHANGELOG.txt"
          "CONTRIBUTING"
          "CONTRIBUTING.md"
          "LICENSE"
          "LICENSE-MIT"
          "LICENSE-APACHE"
          "COPYING"
          "NOTICE"
          "VERSION"
        ];
        "${palette.todo}" = [
          "TODO"
          "TODO.md"
          "TODO.txt"
        ];
        "${palette.text}" = [ ".txt" ];
        "${palette.config}" = [
          ".cfg"
          ".conf"
          ".config"
          ".ini"
          ".json"
          ".toml"
          ".yaml"
          ".yml"
          ".webmanifest"
          ".bashrc"
          ".bash_profile"
          ".zshrc"
          ".zshenv"
          "passwd"
          "shadow"
          "Dockerfile"
        ];
        "${palette.markup}" = [
          ".md"
          ".markdown"
          ".rst"
          ".org"
          ".html"
          ".htm"
          ".xml"
          ".csv"
          ".tsv"
        ];
        "${palette.mediaImage}" = [
          ".png"
          ".jpg"
          ".jpeg"
          ".svg"
          ".webp"
          ".gif"
        ];
        "${palette.mediaAudio}" = [
          ".mp3"
          ".flac"
          ".wav"
          ".ogg"
          ".opus"
        ];
        "${palette.mediaVideo}" = [
          ".mp4"
          ".mkv"
          ".webm"
          ".avi"
        ];
        "${palette.archive}" = [
          ".zip"
          ".tar"
          ".gz"
          ".xz"
          ".zst"
          ".7z"
          ".rar"
        ];
        "${palette.executable}" = [
          ".exe"
          ".bin"
          ".appimage"
        ];
        "${palette.unimportant}" = [
          ".o"
          ".pyc"
          ".class"
          ".log"
          ".tmp"
          ".swp"
          ".lock"
          ".bash_history"
          ".zsh_history"
          ".zcompdump"
          "go.sum"
        ];
      };

      langs = {
        ".nix" = brightCyan;
        ".go" = brightCyan;
        "go.mod" = cyan;
        ".qml" = green;
        ".tmpl" = magenta;
        ".py" = cyan;
        ".rs" = brightRed;
        ".js" = yellow;
        ".ts" = brightBlue;
        ".hs" = magenta;
      };

      coreColors = core |> lib.mapAttrsToList (name: value: "${name}=${value}") |> lib.strings.join ":";
      langColors = langs |> lib.mapAttrsToList (name: value: "*${name}=${value}") |> lib.strings.join ":";
      mkExts = code: exts: builtins.map (ext: "*${ext}=${code}") exts;
      fileColors = files |> lib.mapAttrsToList mkExts |> lib.flatten |> lib.strings.join ":";

      LS_COLORS = "${coreColors}:${langColors}:${fileColors}";

    in
    {
      programs.bash.initExtra = ''
        export LS_COLORS="${LS_COLORS}"
      '';

      programs.zsh.initContent = ''
        export LS_COLORS="${LS_COLORS}"
      '';

      programs.fish.interactiveShellInit = ''
        set -gx LS_COLORS "${LS_COLORS}"
      '';

      programs.nushell.extraEnv = ''
        $env.LS_COLORS = "${LS_COLORS}"
      '';
    };
}
