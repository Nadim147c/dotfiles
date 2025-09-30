{
    delib,
    host,
    pkgs,
    ...
}:
delib.module {
    name = "programs.steam";

    options = delib.singleEnableOption (host.isDesktop && host.gamingFeatured);

    nixos.ifEnabled.programs.steam = {
        enable = true;
        fontPackages = with pkgs; [noto-fonts];
        extraPackages = with pkgs; [mangohud];
        remotePlay.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;

        protontricks.enable = true;
        protontricks.package = pkgs.protontricks;

        gamescopeSession = {
            enable = true;
            args = ["--adaptive-sync" "--rt"];
            env = {
                DXVK_HUD = "fps,gpuload";
            };
            steamArgs = ["-tenfoot"];
        };
    };
}
