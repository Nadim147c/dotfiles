{
  delib,
  host,
  ...
}:
delib.module {
  name = "programs.direnv";

  options = delib.singleEnableOption host.cliFeatured;

  home.ifEnabled = {
    programs.direnv = {
      enable = true;
      silent = true;
      mise.enable = true;
      nix-direnv.enable = true;
      enableBashIntegration = true;
      # enableFishIntegration = true;
      enableNushellIntegration = true;
      enableZshIntegration = true;
    };
  };
}
