{
    description = "Home Manager configuration of ephemeral";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        rong.url = "github:Nadim147c/rong";
        rong.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = {
        nixpkgs,
        home-manager,
        rong,
        ...
    }: let
        system = "x86_64-linux";
        pkgs = import nixpkgs {
            inherit system;
            overlays = [(import ./overlays)];
        };
    in {
        homeConfigurations."ephemeral" = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [
                rong.homeModules.default
                ./home
            ];
        };
    };
}
