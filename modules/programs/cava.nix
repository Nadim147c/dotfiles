{
  delib,
  host,
  lib,
  pkgs,
  xdg,
  ...
}:
delib.module {
  name = "programs.cava";

  options = delib.singleEnableOption host.cliFeatured;

  home.ifEnabled = {
    home.packages = with pkgs; [
      procps
      findutils
    ];

    programs.rong.settings.themes = lib.toList {
      target = "cava.ini";
      links = "${xdg.configHome}/cava/themes/rong";
      cmds = /* bash */ "pidof cava | xargs -r kill -SIGUSR2";
    };

    programs.cava = {
      enable = true;
      settings = {
        color.theme = "rong";
      };
    };
  };
}
