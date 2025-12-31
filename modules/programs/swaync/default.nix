{
  delib,
  host,
  xdg,
  func,
  ...
}:

let
  styleFile = "${xdg.configHome}/swaync/style.scss";
in
delib.module {
  name = "programs.swaync";

  options = delib.singleEnableOption host.guiFeatured;

  home.ifEnabled = {
    xdg.configFile."swaync/style.scss".source = ./style.scss;
    services.swaync.enable = true;

    programs.rong.settings.themes = func.mkList {
      target = "colors.scss";
      links = "${xdg.configHome}/swaync/colors.scss";
      cmds = /* bash */ "compile-scss ${styleFile}";
    };
  };
}
