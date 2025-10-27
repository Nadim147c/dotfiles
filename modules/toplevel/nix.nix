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
                "https://cache.nixos.org/"
                "https://hyprland.cachix.org/"
                "https://nix-community.cachix.org"
                "https://walker.cachix.org"
            ];
            trusted-public-keys = [
                "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
                "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
                "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
                "walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM="
            ];
        };
    };
in
    delib.module {
        name = "nix";
        nixos.always = shared;
        home.always = shared;
    }
