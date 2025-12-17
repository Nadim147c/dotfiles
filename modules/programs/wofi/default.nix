{
  delib,
  hmlib,
  host,
  lib,
  pkgs,
  xdg,
  ...
}:
let
  inherit (lib) getExe;
  compile-scss = getExe pkgs.compile-scss;
  styleFile = "${xdg.configHome}/wofi/style.scss";
in
delib.module {
  name = "programs.wofi";

  options = delib.singleEnableOption host.guiFeatured;

  home.ifEnabled = {
    home.activation.compileWofiStyle = hmlib.dag.entryAfter [ "writeBoundary" ] /* bash */ ''
      install -Dm644 ${./style.scss} ${styleFile}
      ${compile-scss} ${styleFile}
    '';

    programs.rong.settings = {
      links."colors.scss" = [ "${xdg.configHome}/wofi/colors.scss" ];
      post-cmds."colors.scss" = [ "${compile-scss} ${styleFile}" ];
    };

    programs.wofi = {
      enable = true;
      settings = {
        allow_images = true;
        show = "drun";
        term = "kitty";
        matching = "fuzzy";
        key_up = "Ctrl-p";
        key_down = "Ctrl-n";
      };
    };
  };
}
