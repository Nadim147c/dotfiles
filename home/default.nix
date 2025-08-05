{ ... }:
{
  imports = [
    ./dev
    ./rice
    ./desktop
  ];

  programs.nh.enable = true;
  home.stateVersion = "25.05";
  home.username = "ephemeral";
  home.homeDirectory = "/home/ephemeral";

  home.sessionVariables = {
    NH_HOME_FLAKE = "/home/ephemeral/git/dotfiles";
  };

  programs.home-manager.enable = true;
}
