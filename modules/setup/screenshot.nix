{
    config,
    delib,
    host,
    pkgs,
    ...
}:
delib.module {
    name = "setup.screenshot";

    options = delib.singleEnableOption host.isDesktop;

    home.ifEnabled = {myconfig, ...}: let
        inherit (myconfig.constants) username;
        home = config.home-manager.users.${username};

        screenshot-bin = pkgs.writeShellScriptBin "screenshot" ''
            pkill slurp || ${pkgs.hyprshot}/bin/hyprshot -m ''${1:-region} --raw |
              ${pkgs.satty}/bin/satty --filename - \
                --output-filename "${home.xdg.userDirs.pictures}/screenshot-$(date +'%Y-%m-%d_%H-%M-%S').png" \
                --early-exit \
                --actions-on-enter save-to-clipboard \
                --save-after-copy \
                --copy-command "${pkgs.wl-clipboard}/bin/wl-copy"
        '';
        screenshot = "${screenshot-bin}/bin/screenshot";
        desc = ''
            Left Click: Capture a region
            Middle Click: Capture a window
            Right Click: Capture the screen
        '';
    in {
        home.packages = with pkgs; [
            screenshot-bin
            hyprshot
            satty
            slurp
        ];

        wayland.windowManager.hyprland.settings.bind = [
            ",         PRINT, exec, ${screenshot} region"
            "$mainMod, PRINT, exec, ${screenshot} window"
            "SHIFT,    PRINT, exec, ${screenshot} region"
        ];

        programs.waybar.settings.main."custom/screenshot" = {
            format = "󰹑";
            tooltip-format = desc;
            on-click = "${screenshot} region";
            on-click-middle = "${screenshot} window";
            on-click-right = "${screenshot} output";
        };
    };
}
