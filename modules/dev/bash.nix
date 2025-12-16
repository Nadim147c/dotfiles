{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "dev.bash";

  options = delib.singleEnableOption host.devFeatured;

  home.ifEnabled.home.packages = with pkgs; [
    bash-language-server
    shfmt
    shellcheck
    shellharden
  ];
}
