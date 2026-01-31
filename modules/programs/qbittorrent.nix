{
  delib,
  home,
  host,
  lib,
  pkgs,
  utils,
  xdg,
  ...
}:
delib.module {
  name = "programs.qbittorrent";

  options =
    with delib;
    moduleOptions {
      enable = boolOption host.isPC;
      port = intOption 1616;
      settings = attrsOption {
        LegalNotice.Accepted = true;
        Preferences = {
          Downloads.SavePath = "${home.home.homeDirectory}/files/torrents";
          WebUI = {
            AlternativeUIEnabled = true;
            RootFolder = "${pkgs.vuetorrent}/share/vuetorrent";
            AuthSubnetWhitelist = "192.168.1.0/24";
            AuthSubnetWhitelistEnabled = true;
            LocalHostAuth = false;
          };
        };
      };
    };

  home.ifEnabled =
    { cfg, ... }:
    let
      inherit (lib)
        getExe
        escape
        collect
        mapAttrsRecursive
        strings
        ;
      inherit (lib.generators) toINI mkKeyValueDefault mkValueStringDefault;

      gendeepINI = toINI {
        mkKeyValue =
          let
            sep = "=";
            createLine =
              key: path: val:
              let
                name = escape [ sep ] (strings.join "\\" ([ key ] ++ path));
                value = mkValueStringDefault { } val;
              in
              "${name}${sep}${value}";

            attrsToLines =
              key: attrs:
              attrs |> mapAttrsRecursive (createLine key) |> collect builtins.isString |> strings.join "\n";
          in
          k: v: if builtins.isAttrs v then attrsToLines k v else mkKeyValueDefault { } sep k v;
      };

      profileDir = "${xdg.stateHome}/qbittorrent";
      configFile = gendeepINI cfg.settings |> pkgs.writeText "qBittorrent.conf";
    in
    {

      xdg.desktopEntries = {
        qbittorrent-webui = {
          name = "qBittorrent Web UI";
          genericName = "Internet Manager";
          exec = "xdg-open http://localhost:1616";
          terminal = false;
          categories = [
            "Network"
          ];
          icon = "qbittorrent";
          type = "Application";
        };
      };

      # Create directories + config symlink
      systemd.user.tmpfiles.rules = [
        "d ${profileDir}/qBittorrent 0700 - - -"
        "d ${profileDir}/qBittorrent/config 0700 - - -"
        "L+ ${profileDir}/qBittorrent/config/qBittorrent.conf - - - - ${configFile}"
      ];

      systemd.user.services.qbittorrent = {
        Unit = {
          Description = "qBittorrent-nox user";
          After = [ "network-online.target" ];
        };

        Service = {
          ExecStart = utils.escapeSystemdExecArgs [
            (getExe pkgs.qbittorrent-nox)
            "--profile=${profileDir}"
            "--webui-port=${toString cfg.port}"
          ];
          Restart = "on-failure";
          TimeoutStopSec = 1800;
        };

        Install = {
          WantedBy = [ "default.target" ];
        };
      };
    };
}
