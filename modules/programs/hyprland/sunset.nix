{
    delib,
    pkgs,
    ...
}: let
    hyprsunset-temperature = pkgs.writers.writePython3 "hyprsunset-temperature" {} # python

    ''
        from datetime import datetime


        def get_value():
            now = datetime.now().time()
            hour = now.hour + now.minute / 60

            # 5 AM
            start_day = 5
            # 6 PM
            start_fall = 18
            # 10 PM
            end_fall = 22

            if start_day <= hour < start_fall:
                return 8000
            elif start_fall <= hour < end_fall:
                progress = (hour - start_fall) / (end_fall - start_fall)
                return round(8000 - 3000 * progress, 2)
            else:
                return 5000


        if __name__ == "__main__":
            print(int(get_value()))
    '';

    hyprsunset-set-temperature = pkgs.writeShellScript "hyprsunset-set-temperature" ''
        ${pkgs.hyprland}/bin/hyprctl hyprsunset temperature $(${hyprsunset-temperature})
    '';
in
    delib.module {
        name = "programs.hyprland";

        home.ifEnabled = {
            services.hyprsunset.enable = true;

            systemd.user.services.hyprsunset-refresh = {
                Unit = {
                    Description = "Hyprsunset temperature updater";
                    ConditionEnvironment = "WAYLAND_DISPLAY";
                    After = ["hyprsunset.service"];
                    Requires = ["hyprsunset.service"];
                };
                Service = {
                    Type = "oneshot";
                    ExecStart = "${hyprsunset-set-temperature}";
                };
            };

            systemd.user.timers.hyprsunset-refresh = {
                Install.WantedBy = ["timers.target"];
                Unit.Description = "Run hyprsunset temperature updater every 10 minutes";
                Timer = {
                    OnBootSec = "1min";
                    OnUnitActiveSec = "10min";
                    Unit = "hyprsunset-refresh.service";
                };
            };
        };
    }
