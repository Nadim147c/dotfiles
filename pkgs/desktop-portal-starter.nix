{
    writeShellApplication,
    kdePackages,
    xdg-desktop-portal,
    xdg-desktop-portal-hyprland,
}: let
    portal = xdg-desktop-portal;
    kde = kdePackages.xdg-desktop-portal-kde;
    hyprland = xdg-desktop-portal-hyprland;
in
    writeShellApplication {
        name = "desktop-portal-starter";

        runtimeInputs = [portal kde hyprland];

        text = ''
            sleep 1
            killall -e xdg-desktop-portal-hyprland
            killall xdg-desktop-portal
            ${hyprland}/libexec/xdg-desktop-portal-hyprland &
            ${kde}/libexec/xdg-desktop-portal-kde &

            sleep 2
            ${portal}/libexec/xdg-desktop-portal &
        '';
    }
