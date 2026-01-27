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
        templates.draft_commit_description = ''
          concat(
            description,
            surround(
              "\nJJ: This commit contains the following changes:\n", "",
              indent("JJ:     ", diff.summary()),
            ),
            surround(
              "\nJJ: This commit contains the following changes:\n", "",
              indent("JJ:     ", diff.stat(72)),
            ),
            "\n",
            "JJ: ignore-rest\n",
            diff.git(),
          )
        '';
      };
    };
  };
}
