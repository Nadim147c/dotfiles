{
    delib,
    pkgs,
    ...
}:
delib.module {
    name = "programs.hypridle";

    options = {myconfig, ...} @ args: delib.singleEnableOption myconfig.host.isDesktop args;

    home.ifEnabled.home.packages = with pkgs; [hyprlock];
    home.ifEnabled.services.hypridle = {
        enable = true;
        settings = {
            general = {
                lock_cmd = "pidof hyprlock || hyprlock";
                before_sleep_cmd = "loginctl lock-session";
                after_sleep_cmd = "hyprctl dispatch dpms on";
            };
            listeners = [
                {
                    timeout = 295;
                    on-timeout = "notify-send \"Locking the session in 5 seconds\"";
                }
                {
                    timeout = 300;
                    on-timeout = "pidof hyprlock || hyprlock";
                }
                {
                    timeout = 360;
                    on-timeout = "hyprctl dispatch dpms off";
                    on-resume = "hyprctl dispatch dpms on";
                }
            ];
        };
    };
}
