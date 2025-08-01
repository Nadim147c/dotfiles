{
    description = "Home Manager configuration of ephemeral";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = {
        nixpkgs,
        home-manager,
        ...
    }: let
        system = "x86_64-linux";
        pkgs = import nixpkgs {
            inherit system;
            overlays = [
                (import ./overlays/git-sb.nix)
                (import ./overlays/image-detect.nix)
            ];
        };
    in {
        homeConfigurations."ephemeral" = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [./home.nix];
        };
    };
}
