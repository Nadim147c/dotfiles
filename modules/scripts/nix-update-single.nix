{
    delib,
    pkgs,
    ...
}:
delib.script {
    name = "nix-update-single";
    package = pkgs.writeShellScriptBin "nix-update-single" ''
          if [ "$#" -ne 1 ]; then
            echo "Usage: nix-update-single path/to/default.nix"
            exit 1
          fi

          SRC_FILE=$(realpath "$1")
          DIR="$(mktemp -d)"

          cp -vf "$SRC_FILE" "$DIR/default.nix"

          # --- write flake.nix ---
          cat > "$DIR/flake.nix" <<'EOF'
        {
          inputs = {
            nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
            flake-parts.url = "github:hercules-ci/flake-parts";
          };

          outputs = inputs @ { self, flake-parts, ... }:
            flake-parts.lib.mkFlake { inherit inputs; } {
              systems = [
                "x86_64-linux"
                "aarch64-linux"
                "x86_64-darwin"
                "aarch64-darwin"
              ];

              perSystem = { pkgs, ... }: {
                packages.default = pkgs.callPackage ./. {};
              };
            };
        }
        EOF

          # --- copy flake.lock if exists ---
          if [ -f flake.lock ]; then
            cp flake.lock "$DIR/"
          fi

          cd "$DIR"

          # Update the "default" package inside the flake
          ${pkgs.nix-update}/bin/nix-update --flake default

          # Copy the updated file back
          ${pkgs.coreutils-full}/bin/install -m 0644 "$DIR/default.nix" "$SRC_FILE"

          rm -vrf "$DIR"
    '';
}
