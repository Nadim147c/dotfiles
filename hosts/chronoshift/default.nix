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

  myconfig.displays = {
    "eDP-1".enable = false;
    "DP-1" = {
      enable = true;
      primary = true;
      refreshRate = 59.79;
      width = 1366;
      height = 768;
      x = 0;
      y = 0;
    };
  };

  myconfig = {
    dev.cpp.enable = false;
  };

  homeManagerSystem = "x86_64-linux";
  home.home.stateVersion = "26.05";
  nixos.system.stateVersion = "26.05";

  nixos = {
    nixpkgs.hostPlatform = "x86_64-linux";
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

    environment.systemPackages = with pkgs; [
      libva
      libva-utils
    ];

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
