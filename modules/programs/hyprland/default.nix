{
  delib,
  pkgs,
  host,
  xdg,
  func,
  lib,
  ...
}:
let
  inherit (lib) mapAttrsToList;
in
delib.module {
  name = "programs.hyprland";

  options = delib.singleEnableOption host.guiFeatured;

  home.ifEnabled =
    { myconfig, ... }:
    let
      urgentHandler = pkgs.writeShellScript "hyprland-urgent-handler" ''
        hyprctl clients -j |
          ${pkgs.jq}/bin/jq ".[] | select(.address == \"0x$2\").workspace.id" |
          head -n1 |
          xargs -r hyprctl dispatch workspace
      '';
    in
    {
      wayland.windowManager.hyprland = {
        enable = true;
        systemd.enable = false;
        settings = {
          exec-once = [ "sleep 60 && hyprevent urgent ${urgentHandler}" ];
          monitor =
            let
              s = toString;
              # name,size@refresh-rate,position,scale
              format = display: with display; "${s width}x${s height}@${s refreshRate},${s x}x${s y},${s scale}";
              mkMonitor = name: display: "${name},${if display.enable then format display else "disable"}";
            in
            mapAttrsToList mkMonitor myconfig.displays;
        };
      };

      home.packages = with pkgs; [
        hyprcursor
        playerctl
        wl-clipboard
      ];
      services.hyprpolkitagent.enable = true;

      programs.rong.settings.themes = func.mkList {
        target = "hyprland.conf";
        links = "${xdg.configHome}/hypr/colors.conf";
        cmds = "hyprctl reload";
      };
    };

  nixos.ifEnabled.programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
}
