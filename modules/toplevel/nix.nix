{
  delib,
  pkgs,
  lib,
  ...
}:
let
  shared.nix = {
    package = lib.mkForce pkgs.nixVersions.latest;
    settings = {
      eval-cache = true;
      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];
      trusted-users = [
        "root"
        "@wheel"
      ];
      warn-dirty = false;
      substituters = [ "https://cache.nixos.org/" ];
      trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
    };
  };
in
delib.module {
  name = "nix";
  nixos.always = shared;
  home.always = shared;
}
