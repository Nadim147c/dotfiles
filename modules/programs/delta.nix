{
  delib,
  host,
  ...
}:
delib.module {
  name = "programs.delta";

  options = delib.singleEnableOption host.cliFeatured;

  home.ifEnabled.programs.delta = {
    enable = true;
    enableGitIntegration = true;
    enableJujutsuIntegration = true;
    options = {
      navigate = true;
      hunk-header-style = "omit";
      line-numbers = true;
    };
  };
}
