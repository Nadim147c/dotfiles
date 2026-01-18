{
  config,
  delib,
  homedir,
  xdg,
  ...
}:
delib.module {
  name = "programs.rclone";

  # TODO: make the decision which hosts will needs this feature
  options = delib.singleEnableOption true;

  nixos.ifEnabled.programs.fuse = {
    enable = true;
    userAllowOther = true;
  };

  home.ifEnabled.programs.rclone = {
    enable = true;
    remotes = {
      # BACKEND
      gdrive = {
        config = {
          type = "drive";
          scope = "drive";
          config_is_local = true;
          disable_http2 = true;
        };

        secrets = {
          client_id = config.sops.secrets."rclone/gdrive/id".path;
          client_secret = config.sops.secrets."rclone/gdrive/secret".path;
          token = config.sops.secrets."rclone/gdrive/token".path;
        };
      };

      # ENCRYPTED VIEW
      gdrive-enc = {
        config = {
          type = "crypt";
          remote = "gdrive:encrypted"; # folder on Drive where encrypted data lives
          filename_encryption = "standard";
          directory_name_encryption = true;
        };

        secrets = {
          password = config.sops.secrets."rclone/crypt/pass".path;
          password2 = config.sops.secrets."rclone/crypt/salt".path;
        };

        mounts."gdrive" = {
          enable = true;
          mountPoint = "${homedir}/gdrive";
          options = {
            allow-non-empty = true;
            allow-other = true;
            buffer-size = "256M";
            cache-dir = "${xdg.cacheHome}/rclone";
            vfs-cache-mode = "full";
            vfs-read-chunk-size = "128M";
            vfs-read-chunk-size-limit = "1G";
            dir-cache-time = "5000h";
            poll-interval = "15s";
            vfs-cache-max-age = "1h";
            vfs-cache-max-size = "1G";
            umask = "000";
            gid = "100";
          };
        };
      };
    };
  };

}
