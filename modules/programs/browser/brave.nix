{
  delib,
  pkgs,
  host,
  ...
}:
delib.module {
  name = "programs.browsers";

  options.programs.browsers.brave = delib.boolOption host.guiFeature;

  home.ifEnabled.programs.brave = {
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

}
