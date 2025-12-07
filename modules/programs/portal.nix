{
    lib,
    delib,
    pkgs,
    host,
    ...
}:
delib.module {
    name = "xdg.portal";

    options = delib.singleEnableOption host.guiFeatured;

    home.ifEnabled.xdg.portal = {
        enable = true;
        xdgOpenUsePortal = true;
        extraPortals = with pkgs; [
            xdg-desktop-portal-hyprland
            kdePackages.xdg-desktop-portal-kde
        ];
        config.common = let
            portals = {
                Secret = ["gnome-keyring"];
                FileChooser = ["kde"];
            };
            create = k: v: lib.attrsets.nameValuePair "org.freedesktop.impl.portal.${k}" v;
            values = lib.attrsets.mapAttrs' create portals;
        in
            {default = ["hyprland" "kde"];} // values;
    };
}
