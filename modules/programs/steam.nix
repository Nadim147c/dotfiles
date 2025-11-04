{
    delib,
    edge,
    host,
    pkgs,
    ...
}:
delib.module {
    name = "programs.steam";

    options = delib.singleEnableOption host.gamingFeatured;

    nixos.ifEnabled.programs.steam = {
        enable = true;
        fontPackages = with pkgs; [
            noto-fonts
            nerd-fonts.jetbrains-mono
        ];
        extraPackages = with edge; [
            gamemode
            gamescope
            mangohud
            wine
            wine-staging
            winetricks
        ];
        extraCompatPackages = [edge.proton-ge-bin];
        remotePlay.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;

        protontricks.enable = true;
        protontricks.package = edge.protontricks;

        gamescopeSession = {
            enable = true;
            args = ["--adaptive-sync" "--rt"];
            env.DXVK_HUD = "fps,gpuload";
            steamArgs = ["-tenfoot"];
        };
    };
}
