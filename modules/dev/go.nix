{
    config,
    delib,
    pkgs,
    ...
}:
delib.module {
    name = "dev.go";

    options = delib.singleEnableOption true;

    home.ifEnabled = {myconfig, ...}: let
        inherit (myconfig.constants) username;
        xdg = config.home-manager.users.${username}.xdg;
    in {
        home.packages = with pkgs; [gopls gofumpt revive gnumake];
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
