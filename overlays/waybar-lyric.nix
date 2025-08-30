{delib, ...}:
delib.overlayModule {
    name = "waybar-lyric";
    overlay = final: prev: {
        waybar-lyric = let
            inherit (final) buildGoModule fetchFromGitHub installShellFiles lib stdenv;
        in
            buildGoModule (finalAttrs: {
                pname = "waybar-lyric";
                version = "unstable-2025-08-30";

                src = fetchFromGitHub {
                    owner = "Nadim147c";
                    repo = "waybar-lyric";
                    rev = "24e4b70be089a07c616a873b38463d737358ea42";
                    hash = "sha256-ouxMuZBOOS4xe1EEBmAW0wdXT/Klr98K2qEUuyqPrgA=";
                };

                vendorHash = "sha256-49bK9SDNSsTYT4Mmkzn6kLs7CRozxCKEN/jr6QH0JmY=";

                doInstallCheck = true;

                versionCheckKeepEnvironment = ["XDG_CACHE_HOME"];
                preInstallCheck = ''
                    # ERROR Failed to find cache directory
                    export XDG_CACHE_HOME=$(mktemp -d)
                '';

                nativeBuildInputs = [installShellFiles];
                postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
                    installShellCompletion --cmd waybar-lyric \
                            --bash <($out/bin/waybar-lyric _carapace bash) \
                            --fish <($out/bin/waybar-lyric _carapace fish) \
                            --zsh <($out/bin/waybar-lyric _carapace zsh)
                '';

                meta = {
                    description = "Waybar module for displaying song lyrics";
                    homepage = "https://github.com/Nadim147c/waybar-lyric";
                    mainProgram = "waybar-lyric";
                    license = lib.licenses.agpl3Only;
                    platforms = lib.platforms.linux;
                };
            });
    };
}
