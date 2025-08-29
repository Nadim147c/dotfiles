{
    description = "Home Manager configuration of ephemeral";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nixgl.url = "github:nix-community/nixGL";
        catppuccin.url = "github:catppuccin/nix";
        rong.url = "github:Nadim147c/rong";
    };

    outputs = {
        catppuccin,
        home-manager,
        nixgl,
        nixpkgs,
        rong,
        ...
    }: let
        system = "x86_64-linux";
        pkgs = import nixpkgs {
            inherit system;
            overlays = [nixgl.overlay (import ./overlays)];
        };
    in {
        homeConfigurations."ephemeral" = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [
                rong.homeModules.default
                catppuccin.homeModules.catppuccin
                ./home
            ];
        };
    };
}
