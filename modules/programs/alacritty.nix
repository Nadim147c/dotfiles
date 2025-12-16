{
  constants,
  delib,
  host,
  ...
}:
delib.module {
  name = "programs.alacritty";

  options = delib.singleEnableOption host.guiFeatured;

  home.ifEnabled.programs.alacritty = {
    enable = true;
    settings = {
      window.padding = {
        x = 5;
        y = 5;
      };
      font = {
        size = 10;
        normal.family = "JetbrainsMono Nerd Font";
      };
      terminal = {
        shell.program = constants.shell;
        osc52 = "CopyPaste";
      };
    };
  };
}
