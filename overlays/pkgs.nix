{ delib, ... }:
delib.overlayModule {
  name = "pkgs";
  overlay =
    final: prev:
    let
      inherit (prev.lib)
        filterAttrs
        mapAttrsToList
        nameValuePair
        replaceString
        ;
      pkgsDir = builtins.toString ../pkgs;
      mkPkg = name: prev.callPackage "${pkgsDir}/${name}.nix" { };
    in
    builtins.readDir pkgsDir
    |> filterAttrs (k: v: v == "regular")
    |> mapAttrsToList (k: v: k)
    |> builtins.filter (name: builtins.match ".*\\.nix" name != null)
    |> builtins.map (name: replaceString ".nix" "" name)
    |> builtins.map (name: nameValuePair name (mkPkg name))
    |> builtins.listToAttrs;

}
