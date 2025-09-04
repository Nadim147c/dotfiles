{
    delib,
    host,
    pkgs,
    ...
}:
delib.module {
    name = "programs.sddm";

    options = delib.singleEnableOption host.isDesktop;

    nixos.ifEnabled.environment.systemPackages = let
        theme = pkgs.sddm-astronaut.override {embeddedTheme = "post-apocalyptic_hacker";};
    in [theme];
    nixos.ifEnabled.services.displayManager.sddm = {
        enable = true;
        package = pkgs.kdePackages.sddm;
        extraPackages = with pkgs.kdePackages; [
            qtmultimedia
            qtsvg
            qtvirtualkeyboard
        ];
        autoNumlock = true;
        wayland.enable = true;
        theme = "sddm-astronaut-theme";
        settings = {
            Autologin = {
                Session = "hyprland-uwsm.desktop";
                User = "ephemeral";
            };
        };
    };
}
