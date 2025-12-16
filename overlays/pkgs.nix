{ delib, ... }:
delib.overlayModule {
  name = "pkgs";
  overlay =
    final: prev:
    let
      pkgsDir = ../pkgs;
      files = builtins.attrNames (builtins.readDir pkgsDir);
      nixFiles = builtins.filter (name: builtins.match ".*\\.nix" name != null) files;
      imported = builtins.listToAttrs (
        map (name: {
          name = builtins.replaceStrings [ ".nix" ] [ "" ] name;
          value = prev.callPackage (pkgsDir + "/${name}") { };
        }) nixFiles
      );
    in
    imported;
}
