{
  delib,
  host,
  xdg,
  ...
}:
let
  styleFile = "${xdg.configHome}/wofi/style.scss";
in
delib.module {
  name = "programs.wofi";

  options = delib.singleEnableOption host.guiFeatured;

  home.ifEnabled = {
    xdg.configFile."wofi/style.scss".source = ./style.scss;
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

    programs.rong.settings = {
      links."colors.scss" = [ "${xdg.configHome}/wofi/colors.scss" ];
      post-cmds."colors.scss" = [ /* bash */ "compile-scss ${styleFile}" ];
    };
  };
}
