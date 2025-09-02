{delib, ...}:
delib.overlayModule {
    name = "waybar-lyric";
    overlay = final: prev: {
        waybar-lyric = let
            inherit (final) buildGoModule fetchFromGitHub installShellFiles lib stdenv;
        in
            buildGoModule (finalAttrs: {
                pname = "waybar-lyric";
                version = "0.12.0";

                src = fetchFromGitHub {
                    owner = "Nadim147c";
                    repo = "waybar-lyric";
                    rev = "v${finalAttrs.version}";
                    hash = "sha256-UHz4eKHfwrvNMil5DYoSBFqIvhENYd075w86xRoYNCU=";
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
