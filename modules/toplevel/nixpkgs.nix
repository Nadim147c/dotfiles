{
    delib,
    inputs,
    pkgs,
    ...
}: let
    shared.nixpkgs.config = {
        allowUnfree = true;
    };
    files."nixpkgs/config.nix".text = ''
        {
          allowUnfree = true;
        }
    '';
    variables."NIXPKGS_ALLOW_UNFREE" = 1;
in
    delib.module {
        name = "nixpkgs";
        myconfig.always.args.shared = let
        in {
            edge = inputs.unstable.legacyPackages.${pkgs.system};
        };

        nixos.always =
            shared
            // {
                environment.variables = variables;
            };
        home.always =
            shared
            // {
                xdg.configFile = files;
                home.sessionVariables = variables;
            };
    }
