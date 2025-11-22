{
    lib,
    delib,
    ...
}: let
    inherit (delib) extension singleEnableOption;
    inherit (lib) elem mkIf;
in
    extension {
        name = "script";
        description = "Simplified script module";

        libExtension = config: final: _: {
            script = {
                name,
                targets ? ["home"],
                enable ? true,
                package ? null,
            }:
                final.module {
                    name = "scripts.${name}";

                    options = singleEnableOption enable;

                    nixos.ifEnabled = mkIf (elem "nixos" targets) {
                        environment.systemPackages = [package];
                    };

                    home.ifEnabled = mkIf (elem "home" targets) {
                        home.packages = [package];
                    };
                };
        };
    }
