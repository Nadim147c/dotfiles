{lib, ...}: let
  isWSL2 = builtins.getEnv "WSL_DISTRO_NAME" != null;
in {
  imports =
    [
      ./nix/dev.nix
      ./nix/shell.nix
    ]
    ++ lib.optionals (!isWSL2) [./nix/desktop.nix];
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;

  home.username = "ephemeral";
  home.homeDirectory = "/home/ephemeral";
}
