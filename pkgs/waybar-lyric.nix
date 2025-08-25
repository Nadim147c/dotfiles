{
    buildGoModule,
    fetchFromGitHub,
    installShellFiles,
    lib,
    stdenv,
}:
buildGoModule (finalAttrs: {
    pname = "waybar-lyric";
    version = "unstable-2025-08-25";

    src = fetchFromGitHub {
        owner = "Nadim147c";
        repo = "waybar-lyric";
        rev = "27abdd578edd3858309a22e02ded1cba8f2e43cf";
        hash = "sha256-RIpSyQ8JSuB5QpZbmakX8aUgGoYJWQfVVo8415NlI8A=";
    };

    vendorHash = "sha256-DfAB006ntyDCmfsuBpwKo3L372ezFd2q8AWTaeFBjOA=";

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
        license = lib.licenses.agpl3Only;
        mainProgram = "waybar-lyric";
        maintainers = with lib.maintainers; [vanadium5000];
        platforms = lib.platforms.linux;
    };
})
