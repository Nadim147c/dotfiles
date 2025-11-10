{delib, ...}:
delib.module {
    name = "programs.man";

    options = delib.singleEnableOption true;

    home.ifEnabled = {
        manual.manpages.enable = true;
        programs.man = {
            enable = true;
            generateCaches = false; # This takes a long time
        };
    };
}
