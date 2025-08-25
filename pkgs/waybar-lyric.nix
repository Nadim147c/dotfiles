{
    lib,
    buildGoModule,
    fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
    pname = "waybar-lyric";
    version = "unstable-2025-08-25";

    src = fetchFromGitHub {
        owner = "Nadim147c";
        repo = "waybar-lyric";
        rev = "069ee5d2b9289d4992739321ef5006c82a5da9b2";
        hash = "sha256-XaURZF8iH6PeE/eiwpi2IaixzVWpXlmgJ5N6UgeXRfU=";
    };

    vendorHash = "sha256-XGwsD/vPtD5ChF4EQUh/EDvIfZqSM211qptkF5pzvEQ=";

    doInstallCheck = true;

    versionCheckKeepEnvironment = ["XDG_CACHE_HOME"];
    preInstallCheck = ''
        # ERROR Failed to find cache directory
        export XDG_CACHE_HOME=$(mktemp -d)
    '';

    meta = {
        description = "Waybar module for displaying song lyrics";
        homepage = "https://github.com/Nadim147c/waybar-lyric";
        license = lib.licenses.agpl3Only;
        mainProgram = "waybar-lyric";
        maintainers = with lib.maintainers; [vanadium5000];
        platforms = lib.platforms.linux;
    };
})
