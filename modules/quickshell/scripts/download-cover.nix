{
  delib,
  pkgs,
  ...
}:
delib.script {
  name = "download-cover";
  partof = "programs.quickshell";
  package = pkgs.writeShellApplication {
    name = "download-cover.sh";
    runtimeInputs = with pkgs; [
      coreutils
      curl
      systemd
    ];
    text = ''
      URL="$1"

      if [[ -z "$URL" ]]; then
          echo "download-cover <URL>"
          exit 1
      fi

      if [[ "$URL" == file://* ]]; then
          LOCAL_PATH="''${URL#file://}"

          if [[ ! -f "$LOCAL_PATH" ]]; then
              echo "error: local file not found: $LOCAL_PATH" >&2
              exit 1
          fi

          echo "$LOCAL_PATH"
          exit 0
      fi

      # Hash URL → stable filename
      HASH=$(echo -n "$URL" | md5sum | cut -d' ' -f1)

      CACHE_DIR="$(systemd-path user-state-cache)/mpris:covers"
      mkdir -pv "$CACHE_DIR"

      CACHE_FILE="$CACHE_DIR/$HASH"

      # If already cached, skip download
      if [[ -f "$CACHE_FILE" ]]; then
          # NOTE: update cache modified date! will be useful cache cleaning.
          touch "$CACHE_FILE"
          echo "$CACHE_FILE"
          exit 0
      fi

      # Download
      curl -L --fail --silent --show-error "$URL" -o "$CACHE_FILE"

      echo "$CACHE_FILE"
    '';
  };
}
