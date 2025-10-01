{
    delib,
    pkgs,
    ...
}:
delib.host {
    name = "chronoshift";

    type = "desktop";

    features = ["cli" "gaming" "gui" "hacking"];

    nixos = {
        networking.hostName = "chronoshift";
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
        boot.initrd.systemd.enable = true;

        environment.systemPackages = with pkgs; [gcc neovim git nh];
        nix.settings.experimental-features = ["nix-command" "flakes"];

        time.timeZone = "Asia/Dhaka";
        i18n.defaultLocale = "en_US.UTF-8";
        i18n.extraLocaleSettings.LC_ALL = "en_US.UTF-8";

        # Configure keymap in X11
        services.xserver.xkb = {
            layout = "us";
            variant = "";
        };

        # Allow unfree packages
        nixpkgs.config.allowUnfree = true;
    };
}
