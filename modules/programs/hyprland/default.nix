{
  delib,
  pkgs,
  host,
  xdg,
  ...
}:
delib.module {
  name = "programs.hyprland";

  options = delib.singleEnableOption host.guiFeatured;

  home.ifEnabled = {
    wayland.windowManager.hyprland.enable = true;
    wayland.windowManager.hyprland.systemd.enable = false;
    home.packages = with pkgs; [
      hyprcursor
      playerctl
      wl-clipboard
    ];
    services.hyprpolkitagent.enable = true;

    programs.rong.settings = {
      links."hyprland.conf" = "${xdg.configHome}/hypr/colors.conf";
      post-cmds."hyprland.conf" = /* bash */ "hyprctl reload";
    };
  };

  nixos.ifEnabled = {
    programs.hyprland.withUWSM = true;
    programs.hyprland.enable = true;
    environment.variables = {
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
      XDG_MENU_PREFIX = "arch-";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_DESKTOP = "Hyprland";
    };
  };
}
