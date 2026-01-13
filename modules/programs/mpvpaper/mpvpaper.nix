{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "programs.mpvpaper";

  options = delib.singleEnableOption host.guiFeatured;

  home.ifEnabled =
    { cfg, ... }:
    {
      home.packages = with pkgs; [
        mpvpaper
        wallpaper-sh
      ];

      wayland.windowManager.hyprland.settings.bind = [
        "$mainMod, W, exec, ${pkgs.wallpaper-sh}/bin/wallpaper.sh"
      ];

      programs.waybar.settings.main."custom/wallpaper" = {
        format = "󰸉";
        tooltip-format = "Change wallpaper";
        on-click = "${pkgs.wallpaper-sh}/bin/wallpaper.sh";
      };

      systemd.user.services.mpvpaper-daemon = {
        Unit = {
          Description = "mpvpaper wallpaper control daemon";
          After = [ "graphical-session.target" ];
          PartOf = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${cfg.pkgs.mpvpaper-daemon}/bin/mpvpaper-daemon";
          Restart = "on-failure";
          RestartSec = 10;
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
    };
}
