{
    delib,
    host,
    pkgs,
    ...
}:
delib.module {
    name = "programs.thunar";
    options = delib.singleEnableOption host.isDesktop;
    nixos.ifEnabled = {
        services.gvfs.enable = true;
        services.tumbler.enable = true;

        programs.thunar = {
            enable = true;
            plugins = with pkgs.xfce; [
                thunar-archive-plugin
                thunar-media-tags-plugin
                thunar-volman
                pkgs.ffmpegthumbnailer
            ];
        };
    };
}
