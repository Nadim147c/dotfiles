{
  delib,
  pkgs,
  ...
}:
delib.script {
  name = "nix-update-file";
  package = pkgs.writers.writeNuBin "nix-update-file" /* nu */ ''
    # Update a standalone Nix package file (not in nixpkgs or a flake).
    def main [file: string] {
        let fullpath =  $file | path expand

        print $"Updating ($fullpath)"

        echo $"
            {
              pkgs ? import <nixpkgs> { },
            }:
            rec {
              file-package = pkgs.callPackage ($fullpath) { };
            }
        " | save --raw --force /tmp/nix-update.nix

        nix-update -f /tmp/nix-update.nix --override-filename "$FILE" file-package
    }
  '';
}
