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

    home.stateVersion = "25.05";
    home.username = "ephemeral";
    home.homeDirectory = "/home/ephemeral";

    home.sessionVariables = {
    };

    programs.home-manager.enable = true;
}
