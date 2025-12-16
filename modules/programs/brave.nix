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

    home.ifEnabled = {
        programs.brave = {
            enable = true;
            package = pkgs.brave;
            dictionaries = with pkgs; [
                hunspellDictsChromium.en_US
            ];
            commandLineArgs = [
                "--password-store=gnome"
                "--ozone-platform=wayland"
                "--ozone-platform-hint=wayland"
                "--enable-features=TouchpadOverscrollHistoryNavigation"
            ];
            extensions = [
                "bkijmpolkanhdehnlnabfooghjdokakc" # Double-click Image Downloader
                "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
                "dhdgffkkebhmkfjojejmpbldmpobfkfo" # Tampermonkey
                "gebbhagfogifgggkldgodflihgfeippi" # Return YouTube Dislike
                "hkgfoiooedgoejojocmhlaklaeopbecg" # Picture-in-Picture
                "hlkenndednhfkekhgcdicdfddnkalmdm" # Cookie-Editor
                "mnjggcdmjocbbbhaepdhchncahnbgone" # SponsorBlock
                "nffaoalbilbmmfgbnbgppjihopabppdk" # Video Speed Controller
                "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
            ];
        };

        wayland.windowManager.hyprland.settings = with lib; {
            "$browser" = "${getExe pkgs.uwsm} app -- ${getExe pkgs.brave}";
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
