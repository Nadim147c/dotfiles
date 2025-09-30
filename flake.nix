{
    description = "Modular configuration of NixOS, Home Manager, and Nix-Darwin with Denix";

    inputs = {
        catppuccin.url = "github:catppuccin/nix";
        denix = {
            url = "github:yunfachi/denix";
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.home-manager.follows = "home-manager";
            inputs.nix-darwin.follows = "nix-darwin";
        };
        home-manager = {
            url = "github:nix-community/home-manager/master";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nix-darwin = {
            url = "github:nix-darwin/nix-darwin/master";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        rong = {
            url = "github:Nadim147c/rong";
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
                    (base.withConfig {
                        args.enable = true;
                        hosts.features = {
                            features = [
                                "cli"
                                "gaming"
                                "gui"
                                "hacking"
                            ];
                            defaultByHostType = {
                                desktop = ["cli" "gui" "hacking"];
                                server = [];
                            };
                        };
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
