{
    description = "Modular configuration of NixOS and Home Manager with Denix";

    inputs = {
        chromashift = {
            url = "github:Nadim147c/ChromaShift";
            inputs.nixpkgs.follows = "unstable";
        };
        denix = {
            url = "github:yunfachi/denix";
            inputs.home-manager.follows = "home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        home-manager = {
            url = "github:nix-community/home-manager/release-25.05";
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
        quickshell = {
            url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
            inputs.nixpkgs.follows = "unstable";
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
    };
}
