{
  delib,
  host,
  lib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.fzf";

  options = delib.singleEnableOption host.cliFeatured;

  home.ifEnabled.programs.fzf = {
    enable = true;
    enableBashIntegration = false;
    enableFishIntegration = false;
    # enableNushellIntegration = true;
    enableZshIntegration = false;
    defaultOptions = [
      "--border"
      "--ansi"
      "--layout=reverse"
    ];
    defaultCommand = "${pkgs.fd}/bin/fd --type f --color=always";
    colors.bg = lib.mkForce "";
  };
}
