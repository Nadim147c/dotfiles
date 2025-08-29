{
    delib,
    pkgs,
    ...
}:
delib.host {
    name = "chronoshift";

    type = "desktop";

    nixos = {
        networking.hostName = "chronoshift";
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
        boot.initrd.systemd.enable = true;

        environment.systemPackages = with pkgs; [gcc neovim git nh];
        nix.settings.experimental-features = ["nix-command" "flakes"];

        networking.networkmanager.enable = true;

        # Set your time zone.
        time.timeZone = "Asia/Dhaka";

        # Select internationalisation properties.
        i18n.defaultLocale = "en_US.UTF-8";

        i18n.extraLocaleSettings = {
            LC_ADDRESS = "es_US.UTF-8";
            LC_IDENTIFICATION = "es_US.UTF-8";
            LC_MEASUREMENT = "es_US.UTF-8";
            LC_MONETARY = "es_US.UTF-8";
            LC_NAME = "es_US.UTF-8";
            LC_NUMERIC = "es_US.UTF-8";
            LC_PAPER = "es_US.UTF-8";
            LC_TELEPHONE = "es_US.UTF-8";
            LC_TIME = "es_US.UTF-8";
        };

        # Configure keymap in X11
        services.xserver.xkb = {
            layout = "us";
            variant = "";
        };

        # Allow unfree packages
        nixpkgs.config.allowUnfree = true;
    };
}
