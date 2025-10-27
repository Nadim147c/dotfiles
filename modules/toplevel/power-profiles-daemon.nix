{
    delib,
    host,
    ...
}:
delib.module {
    name = "power-profiles-daemon";

    options = delib.singleEnableOption host.isPC;

    nixos.ifEnabled.services.power-profiles-daemon.enable = true;

    home.ifEnabled.programs.waybar.settings.main.power-profiles-daemon = {
        format = "{icon}";
        tooltip-format = "Power profile: {profile}\nDriver: {driver}";
        tooltip = true;
        format-icons = {
            default = "";
            performance = "";
            balanced = "";
            power-saver = "";
        };
    };
}
