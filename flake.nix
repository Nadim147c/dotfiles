{
    description = "Modular configuration of NixOS and Home with unified inputs";

    inputs = {
        denix = {
            url = "github:yunfachi/denix";
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.nixpkgs-lib.follows = "nixpkgs-lib";
            inputs.home-manager.follows = "home-manager";
        };
        home-manager = {
            url = "github:nix-community/home-manager/master";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
        nixos-hardware.url = "github:NixOS/nixos-hardware/master";
        nixpkgs-lib.url = "github:nix-community/nixpkgs.lib";
        nixpkgs.url = "nixpkgs/nixos-unstable";
        rong = {
            url = "github:Nadim147c/rong";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        waybar-lyric = {
            url = "github:Nadim147c/waybar-lyric";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        yankd = {
            url = "github:Nadim147c/yankd";
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
                            features = ["cli" "dev" "gaming" "gui" "hacking" "media" "wireless"];
                            defaultByHostType = {
                                desktop = ["cli" "gui" "hacking"];
                                server = [];
                            };
                        };
                    })
                    (denix.lib.callExtension ./extensions/script.nix)
                ];

                specialArgs = {inherit inputs moduleSystem;};
            };
    in {
        nixosConfigurations = mkConfigurations "nixos";
        homeConfigurations = mkConfigurations "home";
    };
}
