{
  delib,
  host,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) getExe;
in
delib.module rec {
  name = "screenshot";

  options = delib.singleEnableOption host.isDesktop;

  home.ifEnabled =
    let
      screenshot-bin = pkgs.writeShellApplication {
        inherit name;
        runtimeInputs = with pkgs; [
          grim
          libnotify
          satty
          slurp
          systemd
        ];
        text = ''
          NAME=$(date +'%Y-%m-%d_%H-%M-%S')
          TEMP_FILE="/tmp/screenshot_$NAME.png"
          FINAL_PATH="$(systemd-path user-pictures)/screenshot/$NAME.png"

          COLORS="''${XDG_STATE_HOME:-$HOME/.local/state}/rong/colors.bash"
          # shellcheck disable=SC1090
          [[ -f "$COLORS" ]] && source "$COLORS"

          REGION=$(slurp -d -b "''${BACKGROUND:-#222222}88" -c "''${OUTLINE:-#111111}")

          trap 'rm -f "$TEMP_FILE"' EXIT

          grim -g "$REGION" "$TEMP_FILE"

          wl-copy <"$TEMP_FILE"

          ACTION=$(notify-send "Screenshot Captured" "Saved to clipboard" \
            --expire-time="5000" \
            --icon="$TEMP_FILE" \
            --action="annotate=Annotate")

          if [ "$ACTION" = "annotate" ]; then
            satty --filename "$TEMP_FILE" \
              --output-filename "$FINAL_PATH" \
              --early-exit \
              --copy-command wl-copy
          else
            mkdir -p "$(dirname "$FINAL_PATH")"
            cp -p "$TEMP_FILE" "$FINAL_PATH"
          fi
        '';
      };
    in
    {
      home.packages = with pkgs; [
        hyprshot
        satty
        screenshot-bin
        slurp
      ];

      wayland.windowManager.hyprland.settings.bind = [ ", PRINT, exec, ${getExe screenshot-bin}" ];
    };
}
