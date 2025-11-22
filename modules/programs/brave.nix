{
    delib,
    lib,
    host,
    pkgs,
    ...
}:
delib.module {
    name = "programs.brave";

    options = delib.singleEnableOption host.guiFeatured;

    home.ifEnabled = let
        braveFlags = ''
            --password-store=basic
            --ozone-platform=wayland
            --ozone-platform-hint=wayland
            --enable-features=TouchpadOverscrollHistoryNavigation
        '';
    in {
        programs.brave = {
            enable = true;
            package = pkgs.brave;
            dictionaries = [pkgs.hunspellDictsChromium.en_US];
            extensions = [
                "bkijmpolkanhdehnlnabfooghjdokakc" # Double-click Image Downloader
                "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
                "dhdgffkkebhmkfjojejmpbldmpobfkfo" # Tampermonkey
                "fpnmgdkabkmnadcjpehmlllkndpkmiak" # Wayback Machine
                "gebbhagfogifgggkldgodflihgfeippi" # Return YouTube Dislike
                "hkgfoiooedgoejojocmhlaklaeopbecg" # Picture-in-Picture
                "hlkenndednhfkekhgcdicdfddnkalmdm" # Cookie-Editor
                "kekjfbackdeiabghhcdklcdoekaanoel" # MAL-Sync
                "mnjggcdmjocbbbhaepdhchncahnbgone" # SponsorBlock
                "nffaoalbilbmmfgbnbgppjihopabppdk" # Video Speed Controller
                "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
            ];
        };

        xdg.configFile."brave-flags.conf".text = braveFlags;

        wayland.windowManager.hyprland.settings = let
            uwsm = "${lib.getExe pkgs.uwsm} app";
            brave = "${lib.getExe pkgs.brave} ${builtins.replaceStrings ["\n"] [" "] braveFlags}";
        in {
            "$browser" = "${uwsm} -- ${brave}";
        };

        xdg.mimeApps = let
            browser = "brave.desktop";
            mime = {
                "text/html" = [browser];
                "application/pdf" = [browser];
                "x-scheme-handler/about" = [browser];
                "x-scheme-handler/http" = [browser];
                "x-scheme-handler/https" = [browser];
                "x-scheme-handler/unknown" = [browser];
            };
        in {
            associations.added = mime;
            defaultApplications = mime;
        };
    };
}
