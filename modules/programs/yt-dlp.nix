{
    delib,
    pkgs,
    xdg,
    ...
}:
delib.module {
    name = "programs.yt-dlp";

    options = delib.singleEnableOption true;

    home.ifEnabled.programs.yt-dlp = {
        enable = true;
        package = pkgs.yt-dlp;
        settings = {
            paths = xdg.userDirs.download;
            format = "(bv[height<=1080]+ba)/(b[height<=1080])/b";
            output = "%(title)s-%(id)s.%(ext)s";
            merge-output-format = "mp4";
            concurrent-fragments = 4;
            sponsorblock-mark = "all";
            sub-langs = "all";
            embed-subs = true;
            embed-thumbnail = true;
            embed-metadata = true;
            embed-chapters = true;
            color = "always";
            no-simulate = true;
        };
    };
}
