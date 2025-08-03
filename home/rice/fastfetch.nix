{pkgs, ...}: let
    logo = ''
        ⡆⣿⣆⠱⣝⡵⣝⢅⠙⣿⢕⢕⢕⢕⢝⣥⢒⠅⣿⣿⣿⡿⣳⣌⠪⡪⣡⢑⢝⣿
        ⡆⣿⣿⣦⠹⣳⣳⣕⢅⠈⢗⢕⢕⢕⢕⢕⢈⢆⠟⠋⠉⠁⠉⠉⠁⠈⠼⢐⢕⢽
        ⡗⢰⣶⣶⣦⣝⢝⢕⢕⠅⡆⢕⢕⢕⢕⢕⣴⠏⣠⡶⠛⡉⡉⡛⢶⣦⡀⠐⣕⢕
        ⡝⡄⢻⢟⣿⣿⣷⣕⣕⣅⣿⣔⣕⣵⣵⣿⣿⢠⣿⢠⣮⡈⣌⠨⠅⠹⣷⡀⢱⢕
        ⡝⡵⠟⠈⢀⣀⣀⡀⠉⢿⣿⣿⣿⣿⣿⣿⣿⣼⣿⢈⡋⠴⢿⡟⣡⡇⣿⡇⡀⢕
        ⡝⠁⣠⣾⠟⡉⡉⡉⠻⣦⣻⣿⣿⣿⣿⣿⣿⣿⣿⣧⠸⣿⣦⣥⣿⡇⡿⣰⢗⢄
        ⠁⢰⣿⡏⣴⣌⠈⣌⠡⠈⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣬⣉⣉⣁⣄⢖⢕⢕⢕
        ⡀⢻⣿⡇⢙⠁⠴⢿⡟⣡⡆⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣵⣵⣿
        ⡻⣄⣻⣿⣌⠘⢿⣷⣥⣿⠇⣿⣿⣿⣿⣿⣿⠛⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
        ⣷⢄⠻⣿⣟⠿⠦⠍⠉⣡⣾⣿⣿⣿⣿⣿⣿⢸⣿⣦⠙⣿⣿⣿⣿⣿⣿⣿⣿⠟
        ⡕⡑⣑⣈⣻⢗⢟⢞⢝⣻⣿⣿⣿⣿⣿⣿⣿⠸⣿⠿⠃⣿⣿⣿⣿⣿⣿⡿⠁⣠
        ⡝⡵⡈⢟⢕⢕⢕⢕⣵⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣶⣿⣿⣿⣿⣿⠿⠋⣀⣈⠙
        ⡝⡵⡕⡀⠑⠳⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠛⢉⡠⡲⡫⡪⡪⡣'';
    logo-cmd = pkgs.writeShellScript "fastfetch-logo" ''
        if [ -z "$TMUX" ] && [ -z "$ZELLIJ" ]; then
            LOGO=$(${pkgs.fd}/bin/fd . --type f "$HOME/Pictures/fastfetch/" |
        ${pkgs.coreutils}/bin/shuf -n1)
        fi

        if [ -n "$LOGO" ]; then
            echo "$LOGO"
            exit
        fi

        ASCII_LOGO=/tmp/fastfetch.logo
        echo "${logo}" | ${pkgs.lolcat}/bin/lolcat -f -t > $ASCII_LOGO
        echo $ASCII_LOGO
    '';
in {
    programs.fastfetch = {
        enable = true;
        settings = {
            logo = {
                source = "$(${logo-cmd})";
                height = 13;
            };
            general = {
                multithreading = true;
            };
            display = {
                separator = " : ";
            };
            modules = [
                "break"
                {
                    type = "cpu";
                    key = "  CPU";
                    keyColor = "red";
                }
                {
                    type = "gpu";
                    key = "  GPU";
                    keyColor = "blue";
                }
                {
                    type = "memory";
                    key = "  RAM";
                    keyColor = "green";
                }
                "break"
                {
                    type = "title";
                    key = "  SYS";
                    format = "{2}";
                    keyColor = "red";
                }
                {
                    type = "os";
                    key = "  OS ";
                    keyColor = "blue";
                }
                {
                    type = "kernel";
                    key = "  KER";
                    keyColor = "green";
                }
                "break"
                {
                    type = "packages";
                    key = "  PAC";
                    keyColor = "red";
                }
                {
                    type = "shell";
                    key = "  SH ";
                    keyColor = "blue";
                }
                {
                    type = "terminal";
                    key = "  TRM";
                    keyColor = "green";
                }
                "break"
            ];
        };
    };
}
