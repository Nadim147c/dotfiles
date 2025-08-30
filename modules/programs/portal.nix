{
    delib,
    pkgs,
    host,
    ...
}:
delib.module {
    name = "xdg.portal";

    options = delib.singleEnableOption host.isDesktop;

    home.ifEnabled.xdg.portal = {
        enable = true;
        xdgOpenUsePortal = true;
        extraPortals = with pkgs; [
            xdg-desktop-portal-hyprland
            kdePackages.xdg-desktop-portal-kde
        ];
        config.common.default = ["hyprland" "kde"];
    };
}
