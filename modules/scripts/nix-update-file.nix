{
  delib,
  pkgs,
  ...
}:
delib.script rec {
  name = "nix-update-file";
  completion = {
    inherit name;
    flags = {
      "--unstable" = "Use latest commit of current branch";
    };
    completion.positional = [ "$files" ];
  };
  package = pkgs.writeNuApplication {
    inherit name;
    runtimeInputs = with pkgs; [ nix-update ];
    text = /* nu */ ''
      # Update a standalone Nix package file (not in nixpkgs or a flake).
      def main [
        --unstable # Update to latest commit of branch.
        file: string # Nix file to update.
      ] {
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

        let extra_args = if $unstable { [--version=branch] } else { [] }

        nix-update -f /tmp/nix-update.nix --override-filename $file ...$extra_args file-package
      }
    '';
  };
}
