{
    delib,
    host,
    pkgs,
    ...
}:
delib.module {
    name = "programs.dolphin";
    options = delib.singleEnableOption host.guiFeatured;
    home.ifEnabled = {
        home.packages = with pkgs.kdePackages; let
            application-menu = pkgs.runCommandLocal "xdg-application-menu" {} ''
                mkdir -p $out/etc/xdg/menus/
                ln -s ${plasma-workspace}/etc/xdg/menus/plasma-applications.menu $out/etc/xdg/menus/applications.menu
            '';
        in [
            application-menu
            dolphin
            ffmpegthumbs
            kdegraphics-thumbnailers
            kio-admin
            kio-extras
            kio-gdrive
            qtsvg
        ];

        wayland.windowManager.hyprland.settings = {
            "$files" = "${pkgs.uwsm}/bin/uwsm app -- ${pkgs.kdePackages.dolphin}/bin/dolphin";
        };
    };
}
