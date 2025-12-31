{
  pkgs,
  delib,
  host,
  xdg,
  func,
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

    programs.rong.settings.themes = func.mkList {
      target = "cava.ini";
      links = "${xdg.configHome}/cava/config";
      cmds = /* bash */ "pidof cava | xargs -r kill -SIGUSR2";
    };

    programs.cava.enable = true;
  };
}
