{
    buildGoModule,
    fetchFromGitHub,
    installShellFiles,
    lib,
    stdenv,
    ...
}:
buildGoModule rec {
    pname = "waybar-lyric";
    version = "0.12.1";

    src = fetchFromGitHub {
        owner = "Nadim147c";
        repo = "waybar-lyric";
        rev = "v${version}";
        hash = "sha256-ToQap5Aezgf5N6AKLp3D2Ls5mOfdojWpz9Rq9JP3TyM=";
    };

    vendorHash = "sha256-2V79Tvp3oLVcqeK/OMhSwneWRXqv3CJHWPCd4CXk+po=";

    doInstallCheck = false;

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
}
