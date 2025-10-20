{
    delib,
    host,
    xdg,
    ...
}:
delib.module {
    name = "programs.aria2";

    options = delib.singleEnableOption host.cliFeatured;

    home.ifEnabled.programs.aria2 = {
        enable = true;
        settings = {
            allow-overwrite = true;
            allow-piece-length-change = true;
            always-resume = true;
            async-dns = false;
            auto-file-renaming = true;
            content-disposition-default-utf8 = true;
            continue = true;
            dir = xdg.userDirs.download;
            disk-cache = "64M";
            enable-rpc = false;
            file-allocation = "falloc";
            max-concurrent-downloads = 5;
            max-connection-per-server = 5;
            max-download-limit = 0;
            max-overall-download-limit = 0;
            min-split-size = "10M";
            no-file-allocation-limit = "8M";
            save-session = "${xdg.dataHome}/aria2/aria2.session";
            save-session-interval = 60;
            split = 10;
        };
    };
}
