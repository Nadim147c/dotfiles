{
    delib,
    host,
    inputs,
    pkgs,
    ...
}: let
    spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
in
    delib.module {
        name = "programs.spotify";

        options = delib.singleEnableOption host.isDesktop;

        home.always.imports = [inputs.spicetify-nix.homeManagerModules.spicetify];
        home.ifEnabled = {
            programs.spicetify = {
                enable = true;
                enabledExtensions = with spicePkgs.extensions; [
                    adblockify
                    hidePodcasts
                    history
                    lastfm
                    shuffle
                    trashbin
                ];
                enabledCustomApps = [spicePkgs.apps.lyricsPlus];
            };
        };
    }
