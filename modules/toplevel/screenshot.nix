{
  delib,
  host,
  lib,
  pkgs,
  xdg,
  ...
}:
delib.module {
  name = "screenshot";

  options = delib.singleEnableOption host.isDesktop;

  home.ifEnabled =
    let
      screenshot-bin = pkgs.writeShellScriptBin "screenshot" ''
        MODE="''${1:-region}"
        TEMP_FILE="/tmp/screenshot_$(date +'%Y-%m-%d_%H-%M-%S').png"
        FINAL_PATH="${xdg.userDirs.pictures}/screenshot-$(date +'%Y-%m-%d_%H-%M-%S').png"

        case "$MODE" in
            active-window)
                HYPRSHOT_MODES="-m active -m window"
                ;;
            active-output)
                HYPRSHOT_MODES="-m active -m output"
                ;;
            *)
                HYPRSHOT_MODES="-m $MODE"
                ;;
        esac

        pkill slurp || true

        ${pkgs.hyprshot}/bin/hyprshot -z ''${HYPRSHOT_MODES} --silent --raw > "$TEMP_FILE"

        ${pkgs.wl-clipboard}/bin/wl-copy < "$TEMP_FILE"

        ACTION=$(${pkgs.libnotify}/bin/notify-send "Screenshot Captured" "Saved to clipboard" \
            --expire-time="5000" \
            --action="annotate=Annotate")

        if [ "$ACTION" = "annotate" ]; then
            ${pkgs.satty}/bin/satty --filename "$TEMP_FILE" \
                --output-filename "$FINAL_PATH" \
                --early-exit \
                --copy-command "${pkgs.wl-clipboard}/bin/wl-copy"
        else
            cp "$TEMP_FILE" "$FINAL_PATH"
        fi
      '';

      screenshot = "${screenshot-bin}/bin/screenshot";

      desc = ''
        Left Click: Capture a region
        Middle Click: Capture a window
        Right Click: Capture the screen
      '';
    in
    {
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
