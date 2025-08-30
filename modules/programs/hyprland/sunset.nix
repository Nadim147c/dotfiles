{delib, ...}:
delib.module {
    name = "programs.hyprland";

    home.ifEnabled.services.hyprsunset = {
        enable = true;
        settings.porfile = [
            {
                time = "6:00";
                identity = true;
            }
            {
                time = "18:00";
                temperature = 5000;
            }
        ];
    };
}
