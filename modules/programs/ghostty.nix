{
  constants,
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "programs.ghostty";

  options = delib.singleEnableOption host.isPC;

  home.ifEnabled.programs.ghostty = {
    enable = true;
    package = pkgs.ghostty;
    enableZshIntegration = true;
    enableFishIntegration = false;
    enableBashIntegration = false;
    installVimSyntax = true;
    installBatSyntax = true;

    settings = {
      theme = "rong";
      font-family = "JetBrainsMono Nerd Font";
      font-size = 10;
      command = constants.shell;
      window-padding-x = 5;
      window-padding-y = 5;
      bold-is-bright = false;
      window-vsync = true;
    };
  };
}
