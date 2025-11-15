{
    delib,
    inputs,
    host,
    pkgs,
    ...
}:
delib.module {
    name = "programs.quickshell";

    options = delib.singleEnableOption host.devFeatured;

    home.ifEnabled = let
        quickshell = inputs.quickshell.packages.${pkgs.system}.default;
        netspeed = pkgs.buildGoModule {
            pname = "netspeed";
            version = "0.0.1";
            src = ../../src/netspeed;
            vendorHash = null;
            subPackages = [];
        };
    in {
        home.packages = [
            quickshell
            netspeed
            pkgs.kdePackages.qtdeclarative
        ];
        systemd.user.services.quickshell = {
            Unit = {
                Description = "QuickShell config";
                After = ["graphical-session.target"];
                PartOf = ["graphical-session.target"];
            };

            Install.WantedBy = ["graphical-session.target"];

            Service = {
                ExecStart = "${quickshell}/bin/qs -p ${./.}/shell.qml";
            };
        };
    };
}
