{
    delib,
    edge,
    host,
    pkgs,
    ...
}:
delib.module {
    name = "programs.quickshell";

    options = delib.singleEnableOption host.devFeatured;

    home.ifEnabled = let
        netspeed = pkgs.buildGoModule {
            pname = "netspeed";
            version = "0.0.1";
            src = ../../src/netspeed;
            vendorHash = null;
            subPackages = [];
        };
    in {
        home.packages = with edge; [
            kdePackages.qtdeclarative
            netspeed
            quickshell
        ];
        systemd.user.services.quickshell = {
            Unit = {
                Description = "QuickShell config";
                After = ["graphical-session.target"];
                PartOf = ["graphical-session.target"];
            };

            Install.WantedBy = ["graphical-session.target"];

            Service = {
                ExecStart = "${edge.quickshell}/bin/qs -p ${./.}/shell.qml";
            };
        };
    };
}
