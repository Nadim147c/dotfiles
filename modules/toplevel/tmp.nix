{delib, ...}:
delib.module {
    name = "tmp";
    options = delib.singleEnableOption true;
    nixos.ifEnabled = {
        boot.tmp = {
            useTmpfs = true;
            cleanOnBoot = true;
        };
        systemd.services.nix-daemon = {
            environment.TMPDIR = "/var/tmp";
        };
    };
}
