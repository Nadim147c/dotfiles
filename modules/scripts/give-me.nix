{
  delib,
  pkgs,
  ...
}:
delib.script rec {
  name = "give-me";
  package = pkgs.writeShellScriptBin name ''
    /usr/bin/env \
      NIXPKGS_ALLOW_UNFREE=1 \
      NIXPKGS_ALLOW_BROKEN=1 \
      nix shell --impure ''${@/#/nixpkgs#}
  '';
}
