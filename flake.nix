{
    description = "Modular configuration of NixOS, Home Manager, and Nix-Darwin with Denix";

    inputs = {
        catppuccin.url = "github:catppuccin/nix/release-25.05";
        denix = {
            url = "github:yunfachi/denix";
            inputs.home-manager.follows = "home-manager";
            inputs.nix-darwin.follows = "nix-darwin";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        elephant = {
            url = "github:abenz1267/elephant";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        home-manager = {
            url = "github:nix-community/home-manager/release-25.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nix-darwin = {
            url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
        nixos-hardware.url = "github:NixOS/nixos-hardware/master";
        nixpkgs.url = "nixpkgs/nixos-25.05";
        rong = {
            url = "github:Nadim147c/rong";
            inputs.nixpkgs.follows = "unstable";
        };
        unstable.url = "nixpkgs/nixos-unstable";
        walker = {
            url = "github:abenz1267/walker";
            inputs.elephant.follows = "elephant";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = {denix, ...} @ inputs: let
        mkConfigurations = moduleSystem:
            denix.lib.configurations {
                inherit moduleSystem;
                homeManagerUser = "ephemeral";

                paths = [./hosts ./modules ./overlays];

                extensions = with denix.lib.extensions; [
                    args
                    overlays
                    (base.withConfig {
                        args.enable = true;
                        hosts.features = {
                            features = ["cli" "dev" "gaming" "gui" "hacking" "wireless"];
                            defaultByHostType = {
                                desktop = ["cli" "gui" "hacking"];
                                server = [];
                            };
                        };
                    })
                ];

                specialArgs = {inherit inputs moduleSystem;};
            };
    in {
        nixosConfigurations = mkConfigurations "nixos";
        homeConfigurations = mkConfigurations "home";
        darwinConfigurations = mkConfigurations "darwin";
    };
}
