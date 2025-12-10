{
    delib,
    pkgs,
    ...
}:
delib.module {
    name = "programs.gpg";

    options = delib.singleEnableOption true;

    nixos.ifEnabled = {
        services.pcscd.enable = true;
        programs.gnupg.agent = {
            enable = true;
            pinentryPackage = pkgs.pinentry-gnome3;
            enableSSHSupport = true;
        };
    };
    home.ifEnabled = {
        programs.gpg.enable = true;
        services.gpg-agent = {
            enable = true;
            pinentry.package = pkgs.pinentry-gnome3;
        };
    };
}
