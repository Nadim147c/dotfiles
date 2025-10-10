{
    delib,
    host,
    ...
}:
delib.module {
    name = "programs.atuin";

    options = delib.singleEnableOption host.cliFeatured;

    home.ifEnabled.programs.atuin = {
        enable = true;
        daemon.enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableNushellIntegration = true;
        enableZshIntegration = true;
        flags = ["--disable-up-arrow"];
        settings = {
            db_path = "~/.local/share/shell-history.db";
            inline_height = 20;
            invert = true;
            style = "compact";
        };
    };
}
