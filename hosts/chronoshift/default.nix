{
    delib,
    pkgs,
    ...
}:
delib.host {
    name = "chronoshift";

    type = "desktop";

    features = [
        "cli"
        "dev"
        "gui"
        "hacking"
        "media"
        "wireless"
    ];

    home.home.stateVersion = "25.11";
    nixos.system.stateVersion = "25.11";

    myconfig = {
        dev.cpp.enable = false;
    };

    nixos = {
        networking.hostName = "chronoshift";
        boot = {
            loader.systemd-boot = {
                enable = true;
                configurationLimit = 10;
                consoleMode = "max";
            };
            loader.efi.canTouchEfiVariables = true;
            initrd.systemd.enable = true;
            initrd.verbose = false;
            consoleLogLevel = 0;
        };

        environment.systemPackages = with pkgs; [libva libva-utils];

        time.timeZone = "Asia/Dhaka";
        i18n.defaultLocale = "en_US.UTF-8";
        i18n.extraLocaleSettings.LC_ALL = "en_US.UTF-8";

        # Configure keymap in X11
        services.xserver.xkb = {
            layout = "us";
            variant = "";
        };
    };
}
