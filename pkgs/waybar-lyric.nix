{
    stdenv,
    installShellFiles,
    lib,
    buildGoModule,
    fetchFromGitHub,
    versionCheckHook,
    nix-update-script,
}:
buildGoModule rec {
    pname = "waybar-lyric";
    version = "0.14.1";

    src = fetchFromGitHub {
        owner = "Nadim147c";
        repo = "waybar-lyric";
        tag = "v${version}";
        hash = "sha256-Cga3cMmRvVgVPx+H4pqvJIgsph/wTjBSH5BGKNODAfY=";
    };

    vendorHash = "sha256-TeAZDSiww9/v3uQl8THJZdN/Ffp+FsZ3TsRStE3ndKA=";

    ldflags = ["-s" "-w" "-X main.Version=${version}"];
    nativeBuildInputs = [installShellFiles];
    postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) # bash

    ''
        installShellCompletion --cmd waybar-lyric \
        --bash <($out/bin/waybar-lyric _carapace bash) \
        --fish <($out/bin/waybar-lyric _carapace fish) \
        --zsh <($out/bin/waybar-lyric _carapace zsh)
    '';

    doInstallCheck = true;
    nativeInstallCheckInputs = [versionCheckHook];
    versionCheckProgramArg = "--version";
    versionCheckKeepEnvironment = ["XDG_CACHE_HOME"];
    preInstallCheck = ''
        # ERROR Failed to find cache directory
        export XDG_CACHE_HOME=$(mktemp -d)
    '';

    passthru.updateScript = nix-update-script {};

    meta = {
        description = "Waybar module for displaying song lyrics";
        homepage = "https://github.com/Nadim147c/waybar-lyric";
        license = lib.licenses.agpl3Only;
        mainProgram = "waybar-lyric";
        maintainers = with lib.maintainers; [vanadium5000];
        platforms = lib.platforms.linux;
    };
}
