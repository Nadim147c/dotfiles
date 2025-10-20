{
    delib,
    pkgs,
    lib,
    ...
}: let
    shared.nix = {
        package = lib.mkForce pkgs.nixVersions.latest;
        settings = {
            experimental-features = ["nix-command" "flakes"];
            trusted-users = ["root" "@wheel"];
            warn-dirty = false;
            substituters = [
                "https://nix-community.cachix.org"
                "https://cache.nixos.org/"
            ];
            trusted-public-keys = [
                "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
                "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            ];
        };
    };
in
    delib.module {
        name = "nix";
        nixos.always = shared;
        home.always = shared;
    }
