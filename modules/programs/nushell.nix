{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "programs.nushell";

  options = delib.singleEnableOption host.cliFeatured;

  # nushell is almost useless without carapace
  myconfig.ifEnabled.programs.carapace.enable = true;
  home.ifEnabled.programs.nushell = {
    enable = true;
    plugins = with pkgs.nushellPlugins; [
      formats
      query
    ];
    settings = {
      show_banner = false;
      edit_mode = "vi";
      cursor_shape = {
        vi_insert = "line";
        vi_normal = "block";
        emacs = "block";
      };
      history = {
        file_format = "sqlite";
        isolation = false;
        max_size = 5000000;
        sync_on_enter = true;
      };
    };
    extraConfig = /* nu */ ''
      $env.config.completions.external.completer = $carapace_completer
    '';
  };
}
