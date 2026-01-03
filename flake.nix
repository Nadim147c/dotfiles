{
  description = "Modular configuration of NixOS and Home with unified inputs";

  inputs = {
    denix = {
      url = "github:yunfachi/denix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-lib.follows = "nixpkgs-lib";
        home-manager.follows = "home-manager";
      };
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgs-lib.url = "github:nix-community/nixpkgs.lib";
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nvim = {
      url = "github:Nadim147c/nvim";
      flake = false;
    };
    rong = {
      url = "github:Nadim147c/rong";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    yankd = {
      url = "github:Nadim147c/yankd";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
  };

  outputs =
    { denix, ... }@inputs:
    let
      mkConfigurations =
        moduleSystem:
        denix.lib.configurations {
          inherit moduleSystem;
          homeManagerUser = "ephemeral";

          paths = [
            ./hosts
            ./modules
            ./overlays
          ];

          extensions = with denix.lib.extensions; [
            args
            overlays
            (base.withConfig {
              args.enable = true;
              hosts.features = {
                features = [
                  "cli"
                  "dev"
                  "gaming"
                  "gui"
                  "hacking"
                  "media"
                  "wireless"
                ];
                defaultByHostType = {
                  desktop = [
                    "cli"
                    "gui"
                    "hacking"
                  ];
                  server = [ ];
                };
              };
            })
            (denix.lib.callExtension ./extensions/script.nix)
          ];

          specialArgs = { inherit inputs moduleSystem; };
        };
    in
    {
      nixosConfigurations = mkConfigurations "nixos";
      homeConfigurations = mkConfigurations "home";
    };
}
