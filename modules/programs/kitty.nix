{
  constants,
  delib,
  host,
  pkgs,
  xdg,
  ...
}:
delib.module {
  name = "programs.kitty";

  options = delib.singleEnableOption host.isDesktop;
  home.ifEnabled = {
    home.packages = with pkgs; [
      procps
      findutils
    ];
    programs.rong.settings = {
      links."kitty-full.conf" = "${xdg.configHome}/kitty/colors.conf";
      post-cmds."kitty-full.conf" = /* bash */ "pidof kitty | xargs -r kill -SIGUSR1";
    };

    programs.kitty = {
      enable = true;
      extraConfig = /* bash */ ''
        include colors.conf
      '';
      font = {
        name = "JetBrainsMono Nerd Font";
        package = pkgs.nerd-fonts.jetbrains-mono;
        size = 10;
      };
      settings = {
        inherit (constants) shell;
        bold_font = "auto";
        italic_font = "auto";
        bold_italic_font = "auto";
        sync_to_monitor = "no";
        window_margin_width = "5";
        cursor_trail = "1";
        confirm_os_window_close = "0";
      };
      keybindings = {
        "ctrl+minus" = "change_font_size all -0.5";
        "ctrl+=" = "change_font_size all +0.5";
        "ctrl+c" = "copy_or_interrupt";
        "ctrl+v" = "paste_from_clipboard";
      };
    };

  };
}
