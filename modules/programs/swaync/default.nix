{
  delib,
  host,
  xdg,
  ...
}:

let
  styleFile = "${xdg.configHome}/swaync/style.scss";
  mkList = x: [ x ];
in
delib.module {
  name = "programs.swaync";

  options = delib.singleEnableOption host.guiFeatured;

  home.ifEnabled = {
    xdg.configFile."swaync/style.scss".source = ./style.scss;
    services.swaync.enable = true;

    programs.rong.settings = {
      links."colors.scss" = [ "${xdg.configHome}/swaync/colors.scss" ];
      post-cmds."colors.scss" = mkList /* bash */ ''
        compile-scss ${styleFile}
        systemctl --user restart swaync.service
      '';
    };
  };
}
