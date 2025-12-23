{
  delib,
  pkgs,
  ...
}:
delib.script {
  name = "sync-nixpkgs-input";
  package = pkgs.writers.writeNuBin "sync-nixpkgs-input" /* nu */ ''
    # Update nixpkgs input to current nixos nixpkgs revision
    def main [] {
        let rev = nixos-version --json | from json | get nixpkgsRevision
        print $"Updating nixpkgs flake input to ($rev)"
        nix flake update --override-input nixpkgs $"github:NixOS/nixpkgs/($rev)"
    }
  '';
}
