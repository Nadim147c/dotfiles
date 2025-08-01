{pkgs, ...}: let
    my-go-clis = pkgs.callPackage ./go {};
in {
    imports = [
        ./nix/dev.nix
        ./nix/rice.nix
        ./nix/desktop.nix
        ./pkgs/scripts
    ];
    home.packages = [my-go-clis];

    programs.nh.enable = true;
    home.stateVersion = "25.05";
    home.username = "ephemeral";
    home.homeDirectory = "/home/ephemeral";

    home.sessionVariables = {
        NH_HOME_FLAKE = "/home/ephemeral/git/dotfiles";
    };

    programs.home-manager.enable = true;
}
