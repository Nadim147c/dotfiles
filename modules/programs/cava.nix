{
  pkgs,
  delib,
  host,
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

    programs.rong.settings = {
      links."cava.ini" = "${xdg.configHome}/cava/config";
      post-cmds."cava.ini" = /* bash */ "pidof cava | xargs -r kill -SIGUSR2";
    };

    programs.cava.enable = true;
  };
}
