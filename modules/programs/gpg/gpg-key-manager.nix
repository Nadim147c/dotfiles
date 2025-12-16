{
  delib,
  pkgs,
  ...
}:
delib.script {
  name = "gpg-key-manager";
  partof = "programs.gpg";
  package = pkgs.writeShellApplication {
    name = "gpg-key-manager";
    runtimeInputs = with pkgs; [
      gnupg
      gum
    ];
    text = ''
      # Main menu
      ACTION=$(gum choose "Import Private Key" "Export Public Key" "Exit")

      case "$ACTION" in
      "Import Private Key")
          echo "📥 Importing GPG Private Key"
          echo ""

          # Get the key content
          KEY_CONTENT=$(gum write --header "GPG Private Key" --placeholder "Type or paste PGP encoded key here..." --width 80 --height 20)

          if [ -z "$KEY_CONTENT" ]; then
              gum style --foreground 196 "❌ No key provided. Aborting."
              exit 1
          fi

          # Import the key
          if echo "$KEY_CONTENT" | gpg --import 2>&1 | tee /tmp/gpg-import.log; then
              gum style --foreground 46 "✅ Key imported successfully!"

              # Show imported keys
              echo ""
              gum style --bold "Imported key details:"
              gpg --list-secret-keys --keyid-format LONG
          else
              gum style --foreground 196 "❌ Failed to import key. Check the format and try again."
              cat /tmp/gpg-import.log
              exit 1
          fi
          ;;

      "Export Public Key")
          echo "📤 Exporting GPG Public Key"
          echo ""

          # List available keys
          KEYS=$(gpg --list-secret-keys --keyid-format LONG --with-colons | grep '^sec' | cut -d: -f5)

          if [ -z "$KEYS" ]; then
              gum style --foreground 196 "❌ No private keys found. Import a key first."
              exit 1
          fi

          # Let user choose a key
          SELECTED_KEY=$(echo "$KEYS" | gum choose --header "Select a key to export:")

          if [ -z "$SELECTED_KEY" ]; then
              gum style --foreground 196 "❌ No key selected. Aborting."
              exit 1
          fi

          # Choose output format
          FORMAT=$(gum choose "Display to terminal" "Save to file")

          case "$FORMAT" in
          "Display to terminal")
              echo ""
              gum style --bold "Public Key for $SELECTED_KEY:"
              echo ""
              gpg --armor --export "$SELECTED_KEY"
              ;;

          "Save to file")
              FILENAME=$(gum input --placeholder "Enter filename (e.g., public-key.asc)" --value "public-key-$SELECTED_KEY.asc")

              if [ -z "$FILENAME" ]; then
                  gum style --foreground 196 "❌ No filename provided. Aborting."
                  exit 1
              fi

              if gpg --armor --export "$SELECTED_KEY" >"$FILENAME"; then
                  gum style --foreground 46 "✅ Public key exported to: $FILENAME"
              else
                  gum style --foreground 196 "❌ Failed to export key."
                  exit 1
              fi
              ;;
          esac
          ;;

      "Exit")
          gum style --foreground 33 "👋 Goodbye!"
          exit 0
          ;;
      esac
    '';
  };
}
