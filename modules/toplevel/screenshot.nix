{
    delib,
    edge,
    host,
    lib,
    pkgs,
    xdg,
    ...
}:
delib.module {
    name = "screenshot";

    options = delib.singleEnableOption host.isDesktop;

    home.ifEnabled = let
        screenshot-bin = pkgs.writeShellScriptBin "screenshot" ''
            pkill slurp || ${pkgs.hyprshot}/bin/hyprshot -m ''${1:-region} --raw |
                ${edge.satty}/bin/satty --filename - \
                --output-filename "${xdg.userDirs.pictures}/screenshot-$(date +'%Y-%m-%d_%H-%M-%S').png" \
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
            hyprshot
            satty
            screenshot-bin
            slurp
        ];

        wayland.windowManager.hyprland.settings.bind = [
            ",         PRINT, exec, ${screenshot} region"
            "$mainMod, PRINT, exec, ${screenshot} window"
            "SHIFT,    PRINT, exec, ${screenshot} region"
        ];

        programs.waybar.settings.main."custom/screenshot" = {
            format = "󰹑";
            tooltip-format = lib.strings.removeSuffix "\n" desc;
            on-click = "${screenshot} region";
            on-click-middle = "${screenshot} window";
            on-click-right = "${screenshot} output";
        };
    };
}
