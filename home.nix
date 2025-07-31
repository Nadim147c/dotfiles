{...}: {
    imports = [
        ./nix/dev.nix
        ./nix/rice.nix
        ./nix/desktop.nix
    ];

    home.stateVersion = "25.05";
    home.username = "ephemeral";
    home.homeDirectory = "/home/ephemeral";

    home.sessionVariables = {
    };

    programs.home-manager.enable = true;
}
