{
  delib,
  host,
  pkgs,
  func,
  ...
}:
delib.module {
  name = "programs.brave";

  options = delib.singleEnableOption host.guiFeatured;

  home.ifEnabled = {
    programs.brave = {
      enable = true;
      dictionaries = [ pkgs.hunspellDictsChromium.en_US ];
      commandLineArgs = [
        "--password-store=gnome"
        "--ozone-platform=wayland"
        "--ozone-platform-hint=wayland"
        "--enable-features=TouchpadOverscrollHistoryNavigation"
      ];
      extensions = [
        "bkijmpolkanhdehnlnabfooghjdokakc" # Double-click Image Downloader
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
        "hkgfoiooedgoejojocmhlaklaeopbecg" # Picture-in-Picture
        "hlkenndednhfkekhgcdicdfddnkalmdm" # Cookie-Editor
        "mnjggcdmjocbbbhaepdhchncahnbgone" # SponsorBlock
        "nffaoalbilbmmfgbnbgppjihopabppdk" # Video Speed Controller
        "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
      ];
    };

    wayland.windowManager.hyprland.settings = {
      "$browser" = func.wrapUWSM pkgs.brave;
    };

    xdg.mimeApps = func.genMimes "brave.desktop" [
      "application/pdf"
      "text/html"
      "x-scheme-handler/about"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "x-scheme-handler/unknown"
    ];
  };
}
