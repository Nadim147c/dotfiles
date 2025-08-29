{delib, ...}:
delib.module {
    name = "programs.hyprland";

    home.ifEnabled.services.hyprsunset = {
        enable = true;
    };
}
