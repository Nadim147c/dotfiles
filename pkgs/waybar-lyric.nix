{
    lib,
    buildGoModule,
    fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
    pname = "waybar-lyric";
    version = "unstable-2025-08-21";

    src = fetchFromGitHub {
        owner = "Nadim147c";
        repo = "waybar-lyric";
        rev = "4b69b0aa1fb72eb0250a8ea5bc6e523a82920aeb";
        hash = "sha256-mPnI/Ey2O2ePNFwfCQH9Pxquuy9Q2huHqMhRj2Fj8oY=";
    };

    vendorHash = "sha256-MH6uHfqL22juWBauNNW3PegXQ3U7jG/oOH7nJWH4WpM=";

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
