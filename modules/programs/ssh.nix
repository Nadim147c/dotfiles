{
  delib,
  pkgs,
  ...
}:
let
  helper = pkgs.writeShellApplication {
    name = "ssh-key-manager";
    runtimeInputs = with pkgs; [
      coreutils
      gum
      openssh
    ];
    text = ''
      # Ensure SSH directory exists
      mkdir -p ~/.ssh
      chmod 700 ~/.ssh

      # Main menu
      ACTION=$(gum choose "Import Private Key" "Export Public Key" "Generate New Key Pair" "Change Key Passphrase" "Exit")

      case "$ACTION" in
      "Import Private Key")
          echo "📥 Importing SSH Private Key"
          echo ""

          # Get the key content
          KEY_CONTENT=$(gum write --header "SSH Private Key" --placeholder "Type or paste private key here (including BEGIN/END lines)..." --width 80 --height 20)

          if [ -z "$KEY_CONTENT" ]; then
              gum style --foreground 196 "❌ No key provided. Aborting."
              exit 1
          fi

          # Get filename for the key
          FILENAME=$(gum input --placeholder "Enter filename for private key" --value "id_imported")

          if [ -z "$FILENAME" ]; then
              gum style --foreground 196 "❌ No filename provided. Aborting."
              exit 1
          fi

          KEYPATH="$HOME/.ssh/$FILENAME"

          # Check if file exists
          if [ -f "$KEYPATH" ]; then
              OVERWRITE=$(gum confirm "File $FILENAME already exists. Overwrite?" && echo "yes" || echo "no")
              if [ "$OVERWRITE" = "no" ]; then
                  gum style "⚠️  Import cancelled."
                  exit 0
              fi
          fi

          # Save the private key
          echo "$KEY_CONTENT" >"$KEYPATH"
          chmod 600 "$KEYPATH"

          # Validate the key
          if ssh-keygen -l -f "$KEYPATH" >/dev/null 2>&1; then
              gum style --foreground 46 "✅ Private key imported successfully!"
              echo ""
              gum style --bold "Key details:"
              ssh-keygen -l -f "$KEYPATH"
              echo ""
              gum style "💡 Key saved to: $KEYPATH"

              # Ask if user wants to generate/import public key
              if gum confirm "Generate corresponding public key?"; then
                  ssh-keygen -y -f "$KEYPATH" >"$KEYPATH.pub"
                  chmod 644 "$KEYPATH.pub"
                  gum style --foreground 46 "✅ Public key generated: $KEYPATH.pub"
              fi
          else
              gum style --foreground 196 "❌ Invalid SSH private key format."
              rm -f "$KEYPATH"
              exit 1
          fi
          ;;

      "Export Public Key")
          echo "📤 Exporting SSH Public Key"
          echo ""

          # Find all private keys in ~/.ssh
          PRIVATE_KEYS=$(find ~/.ssh -type f -name "id_*" ! -name "*.pub" 2>/dev/null || true)

          if [ -z "$PRIVATE_KEYS" ]; then
              gum style --foreground 196 "❌ No SSH private keys found in ~/.ssh/"
              exit 1
          fi

          # Let user choose a key
          SELECTED_KEY=$(echo "$PRIVATE_KEYS" | gum choose --header "Select a key to export public key from:")

          if [ -z "$SELECTED_KEY" ]; then
              gum style --foreground 196 "❌ No key selected. Aborting."
              exit 1
          fi

          # Choose output format
          FORMAT=$(gum choose "Display to terminal" "Save to file" "Copy to clipboard")

          case "$FORMAT" in
          "Display to terminal")
              echo ""
              gum style --bold "Public Key for $(basename "$SELECTED_KEY"):"
              echo ""
              if [ -f "$SELECTED_KEY.pub" ]; then
                  cat "$SELECTED_KEY.pub"
              else
                  ssh-keygen -y -f "$SELECTED_KEY"
              fi
              ;;

          "Save to file")
              FILENAME=$(gum input --placeholder "Enter filename (e.g., id_rsa.pub)" --value "$(basename "$SELECTED_KEY").pub")

              if [ -z "$FILENAME" ]; then
                  gum style --foreground 196 "❌ No filename provided. Aborting."
                  exit 1
              fi

              if ssh-keygen -y -f "$SELECTED_KEY" >"$FILENAME"; then
                  chmod 644 "$FILENAME"
                  gum style --foreground 46 "✅ Public key exported to: $FILENAME"
              else
                  gum style --foreground 196 "❌ Failed to export key."
                  exit 1
              fi
              ;;

          "Copy to clipboard")
              if command -v xclip >/dev/null 2>&1; then
                  ssh-keygen -y -f "$SELECTED_KEY" | xclip -selection clipboard
                  gum style --foreground 46 "✅ Public key copied to clipboard!"
              elif command -v pbcopy >/dev/null 2>&1; then
                  ssh-keygen -y -f "$SELECTED_KEY" | pbcopy
                  gum style --foreground 46 "✅ Public key copied to clipboard!"
              elif command -v wl-copy >/dev/null 2>&1; then
                  ssh-keygen -y -f "$SELECTED_KEY" | wl-copy
                  gum style --foreground 46 "✅ Public key copied to clipboard!"
              else
                  gum style --foreground 196 "❌ No clipboard utility found (xclip, pbcopy, or wl-copy)."
                  echo ""
                  ssh-keygen -y -f "$SELECTED_KEY"
              fi
              ;;
          esac
          ;;

      "Generate New Key Pair")
          echo "🔑 Generating New SSH Key Pair"
          echo ""

          # Get key details
          KEY_TYPE=$(gum choose --header "Select key type:" "ed25519" "rsa" "ecdsa")

          FILENAME=$(gum input --placeholder "Enter filename for new key" --value "id_$KEY_TYPE")

          if [ -z "$FILENAME" ]; then
              gum style --foreground 196 "❌ No filename provided. Aborting."
              exit 1
          fi

          KEYPATH="$HOME/.ssh/$FILENAME"

          # Check if file exists
          if [ -f "$KEYPATH" ]; then
              OVERWRITE=$(gum confirm "File $FILENAME already exists. Overwrite?" && echo "yes" || echo "no")
              if [ "$OVERWRITE" = "no" ]; then
                  gum style "⚠️  Generation cancelled."
                  exit 0
              fi
          fi

          COMMENT=$(gum input --placeholder "Enter comment/email (optional)" --value "")

          # Get passphrase
          gum style "Enter passphrase for new key (press Enter for no passphrase):"
          PASSPHRASE=$(gum input --placeholder "Passphrase" --password)

          # Generate the key
          if [ "$KEY_TYPE" = "rsa" ]; then
              KEY_SIZE=$(gum choose --header "Select key size:" "4096" "2048")
              if [ -n "$COMMENT" ]; then
                  echo "$PASSPHRASE" | ssh-keygen -t "$KEY_TYPE" -b "$KEY_SIZE" -f "$KEYPATH" -C "$COMMENT" -N "$PASSPHRASE" -P "" >/dev/null 2>&1
              else
                  echo "$PASSPHRASE" | ssh-keygen -t "$KEY_TYPE" -b "$KEY_SIZE" -f "$KEYPATH" -N "$PASSPHRASE" -P "" >/dev/null 2>&1
              fi
          else
              if [ -n "$COMMENT" ]; then
                  echo "$PASSPHRASE" | ssh-keygen -t "$KEY_TYPE" -f "$KEYPATH" -C "$COMMENT" -N "$PASSPHRASE" -P "" >/dev/null 2>&1
              else
                  echo "$PASSPHRASE" | ssh-keygen -t "$KEY_TYPE" -f "$KEYPATH" -N "$PASSPHRASE" -P "" >/dev/null 2>&1
              fi
          fi

          if ssh-keygen -l -f "$KEYPATH" >/dev/null 2>&1; then
              chmod 600 "$KEYPATH"
              chmod 644 "$KEYPATH.pub"
              gum style --foreground 46 "✅ Key pair generated successfully!"
              echo ""
              gum style --bold "Key details:"
              ssh-keygen -l -f "$KEYPATH"
              echo ""
              gum style "💡 Private key: $KEYPATH"
              gum style "💡 Public key: $KEYPATH.pub"
          else
              gum style --foreground 196 "❌ Failed to generate key pair."
              exit 1
          fi
          ;;

      "Change Key Passphrase")
          echo "🔐 Changing SSH Key Passphrase"
          echo ""

          # Find all private keys in ~/.ssh
          PRIVATE_KEYS=$(find ~/.ssh -type f -name "id_*" ! -name "*.pub" 2>/dev/null || true)

          if [ -z "$PRIVATE_KEYS" ]; then
              gum style --foreground 196 "❌ No SSH private keys found in ~/.ssh/"
              exit 1
          fi

          # Let user choose a key
          SELECTED_KEY=$(echo "$PRIVATE_KEYS" | gum choose --header "Select a key to change passphrase:")

          if [ -z "$SELECTED_KEY" ]; then
              gum style --foreground 196 "❌ No key selected. Aborting."
              exit 1
          fi

          echo ""
          gum style --bold "Selected key: $(basename "$SELECTED_KEY")"
          echo ""

          # Get current passphrase
          gum style "Enter current passphrase (leave empty if no passphrase):"
          OLD_PASSPHRASE=$(gum input --placeholder "Current passphrase" --password)

          # Get new passphrase
          gum style "Enter new passphrase (leave empty for no passphrase):"
          NEW_PASSPHRASE=$(gum input --placeholder "New passphrase" --password)

          # Confirm new passphrase
          gum style "Confirm new passphrase:"
          CONFIRM_PASSPHRASE=$(gum input --placeholder "Confirm new passphrase" --password)

          # Verify new passphrases match
          if [ "$NEW_PASSPHRASE" != "$CONFIRM_PASSPHRASE" ]; then
              gum style --foreground 196 "❌ Passphrases do not match. Aborting."
              exit 1
          fi

          # Change the passphrase
          if ssh-keygen -p -f "$SELECTED_KEY" -P "$OLD_PASSPHRASE" -N "$NEW_PASSPHRASE" >/dev/null 2>&1; then
              gum style --foreground 46 "✅ Passphrase changed successfully!"
              echo ""
              gum style --bold "Key details:"
              ssh-keygen -l -f "$SELECTED_KEY"
          else
              gum style --foreground 196 "❌ Failed to change passphrase. (Incorrect current passphrase?)"
              exit 1
          fi
          ;;

      "Exit")
          gum style "👋 Goodbye!"
          exit 0
          ;;
      esac
    '';
  };
in
delib.module {
  name = "programs.ssh";
  options = delib.singleEnableOption true;
  home.ifEnabled.home.packages = [
    helper
    pkgs.openssh
  ];
}
