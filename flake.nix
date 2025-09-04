{
    description = "Modular configuration of NixOS, Home Manager, and Nix-Darwin with Denix";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/ae4cafd6d07334999cf06645201e041c7a1cfdda";
        home-manager = {
            url = "github:nix-community/home-manager/master";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nix-darwin = {
            url = "github:nix-darwin/nix-darwin/master";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        denix = {
            url = "github:yunfachi/denix";
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.home-manager.follows = "home-manager";
            inputs.nix-darwin.follows = "nix-darwin";
        };
        zen-browser = {
            url = "github:0xc000022070/zen-browser-flake";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        rong.url = "github:Nadim147c/rong";
        nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    };

    outputs = {denix, ...} @ inputs: let
        mkConfigurations = moduleSystem:
            denix.lib.configurations {
                inherit moduleSystem;
                homeManagerUser = "ephemeral";

                paths = [./hosts ./modules ./overlays];

                extensions = with denix.lib.extensions; [
                    args
                    (base.withConfig {
                        args.enable = true;
                    })
                    (denix.lib.callExtension ./extensions/overlay.nix)
                ];

                specialArgs = {
                    inherit inputs;
                };
            };
    in {
        nixosConfigurations = mkConfigurations "nixos";
        homeConfigurations = mkConfigurations "home";
        darwinConfigurations = mkConfigurations "darwin";
    };
}
