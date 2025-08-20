{
  coreutils,
  eggdbus,
  util-linux,
  writeShellApplication,
}:
writeShellApplication {
  name = "pfp";

  runtimeInputs = [eggdbus coreutils util-linux];

  text = ''
    #!/bin/bash

    subcommand="$1"
    shift || true

    case "$subcommand" in
      get)
        gdbus call --system \
          --dest org.freedesktop.Accounts \
          --object-path /org/freedesktop/Accounts/User"$(id -u)" \
          --method org.freedesktop.DBus.Properties.Get \
          org.freedesktop.Accounts.User IconFile |
          cut -d\' -f2
        ;;

      set)
        # AUTO-ELEVATE TO ROOT IF NOT ALREADY
        if [[ $EUID -ne 0 ]]; then
            exec sudo "$0" "$subcommand" "$@"
        fi

        if [[ $# -lt 1 ]]; then
            echo "Usage: pfp set /path/to/image.jpg"
            exit 1
        fi

        IMAGE_PATH="$1"
        USERNAME="''${SUDO_USER:-$USER}"
        ICON_DIR="/var/lib/AccountsService/icons"
        USER_FILE="/var/lib/AccountsService/users/$USERNAME"

        if [[ -z "$USERNAME" ]]; then
            echo "Could not determine target username."
            exit 2
        fi

        if [[ ! -f "$IMAGE_PATH" ]]; then
            echo "Image file not found: $IMAGE_PATH"
            exit 3
        fi

        cp "$IMAGE_PATH" "$ICON_DIR/$USERNAME"
        chown root:root "$ICON_DIR/$USERNAME"

        mkdir -p "$(dirname "$USER_FILE")"

        if [[ ! -f "$USER_FILE" ]]; then
            echo "[User]" > "$USER_FILE"
        fi

        if grep -q '^Icon=' "$USER_FILE"; then
            sed -i "s|^Icon=.*|Icon=$ICON_DIR/$USERNAME|" "$USER_FILE"
        else
            echo "Icon=$ICON_DIR/$USERNAME" >> "$USER_FILE"
        fi

        echo "Profile picture set for user '$USERNAME'. Log out or reboot to see the change."
        ;;

      *)
        echo "Usage: pfp {get|set <image-path>}"
        exit 1
        ;;
    esac
  '';
}
