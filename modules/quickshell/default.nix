{
  delib,
  func,
  host,
  inputs,
  pkgs,
  xdg,
  ...
}:
delib.module {
  name = "programs.quickshell";

  options = delib.singleEnableOption host.guiFeatured;

  home.ifEnabled = {
    home.packages = with pkgs; [
      kdePackages.qt5compat
      kdePackages.qtdeclarative
    ];

    xdg.configFile."quickshell".source = ./.;

    programs.rong.settings.installs = {
      "quickshell.json" = "${xdg.stateHome}/quickshell/colors.json";
    };

    programs.quickshell = {
      enable = true;
      package = (func.flakePackage inputs.quickshell).overrideAttrs (oldAttrs: {
        buildInputs = with pkgs; [
          qt6.qtimageformats
          qt6.qtmultimedia
          qt-m3shapes
        ];
      });
      systemd.enable = true;
    };

    wayland.windowManager.hyprland.settings.bind = [
      "$mainMod, V, global, quickshell:toggle-clipboard"
    ];
  };
}
