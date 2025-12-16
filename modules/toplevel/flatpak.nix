{
  delib,
  host,
  inputs,
  ...
}:
delib.module {
  name = "flatpak";
  options = delib.singleEnableOption host.isDesktop;
  nixos.always.imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];
  nixos.ifEnabled.services.flatpak = {
    enable = true;
    overrides = {
      global = {
        # Fix cursor
        Context.filesystems = [
          "$HOME/.local/share/fonts:ro"
          "$HOME/.icons:ro"
          "$HOME/.config/gtk-3.0:ro"
          "$HOME/.config/gtk-4.0:ro"
          "/nix/store:ro"
        ];

        # Force Wayland by default
        Context.sockets = [
          "wayland"
          "!x11"
          "!fallback-x11"
        ];
      };
    };
    packages = [ "com.github.tchx84.Flatseal" ];
  };
}
