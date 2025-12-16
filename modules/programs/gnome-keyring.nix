{
  delib,
  host,
  ...
}:
delib.module {
  name = "programs.gnome-keyring";

  options = delib.singleEnableOption host.cliFeatured;

  home.ifEnabled.services.gnome-keyring = {
    enable = true;
    components = [
      "pkcs11"
      "secrets"
      "ssh"
    ];
  };
  nixos.ifEnabled = {
    services.gnome.gnome-keyring.enable = true;
    security.pam.services.login.enableGnomeKeyring = true;
  };
}
