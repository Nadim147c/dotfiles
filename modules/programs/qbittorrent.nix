{
    delib,
    host,
    pkgs,
    ...
}:
delib.module {
    name = "programs.qbittorrent";
    options = delib.singleEnableOption false;
    home.ifEnabled = {
        home.packages = with pkgs; [qbittorrent];
        systemd.user.services.qbittorrent = {
            Unit = {
                Description = "qBittorrent client";
                After = [
                    "graphical-session.target"
                    "tray.target"
                ];
                PartOf = ["graphical-session.target"];
                Requires = ["tray.target"];
            };

            Install.WantedBy = ["graphical-session.target"];

            Service = {
                ExecStart = "${pkgs.qbittorrent}/bin/qbittorrent";
                Restart = "no"; # do not restart when closed manually
            };
        };
    };
}
