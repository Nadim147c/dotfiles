{
  constants,
  delib,
  host,
  ...
}:
delib.module {
  name = "programs.jujutsu";

  options = delib.singleEnableOption host.devFeatured;

  home.ifEnabled = {
    programs.jujutsu = {
      enable = true;
      settings = {
        user.name = constants.fullname;
        user.email = constants.email;
        ui.default-command = "log";
        signing = {
          behavior = "own";
          backend = "ssh";
          key = "~/.ssh/master.pub";
        };
      };
    };
  };
}
