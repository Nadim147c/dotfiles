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
  styleFile = "${xdg.configHome}/swaync/style.scss";
in
delib.module {
  name = "programs.swaync";

  options = delib.singleEnableOption host.guiFeatured;

  home.ifEnabled = {
    home.activation.compileSwayncStyle = hmlib.dag.entryAfter [ "writeBoundary" ] /* bash */ ''
      install -Dm644 ${./style.scss} ${styleFile}
      ${compile-scss} ${styleFile}
    '';

    programs.rong.settings = {
      links."colors.scss" = [ "${xdg.configHome}/swaync/colors.scss" ];
      post-cmds."colors.scss" = [
        /* bash */ ''
          ${compile-scss} ${styleFile}
          swaync-client --reload-css
        ''
      ];
    };

    services.swaync.enable = true;
  };
}
