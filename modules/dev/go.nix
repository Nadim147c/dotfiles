{
    edge,
    delib,
    host,
    pkgs,
    xdg,
    ...
}:
delib.module {
    name = "dev.go";

    options = delib.singleEnableOption host.devFeatured;

    home.ifEnabled = {
        home.packages =
            (with pkgs; [
                gnumake
                gofumpt
                gopls
            ])
            ++ [edge.revive];
        home.sessionVariables = {
            GOMODCACHE = "${xdg.cacheHome}/go/mod";
            GOBIN = "${xdg.dataHome}/go/bin";
            GOPATH = "${xdg.dataHome}/go";
        };
        programs.go = {
            enable = true;
            telemetry.mode = "off";
            goPath = ".local/share/go";
            goBin = ".local/share/go/bin";
        };
    };
}
