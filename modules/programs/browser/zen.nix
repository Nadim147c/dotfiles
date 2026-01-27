{
  inputs,
  delib,
  lib,
  host,
  pkgs,
  ...
}:
let
  addons = inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system};
  inherit (lib) attrsToList toList;
in
delib.module {
  name = "programs.browsers";

  options.programs.browsers.zen = delib.boolOption host.guiFeatured;

  home.always.imports = [ inputs.zen-browser.homeModules.beta ];

  home.ifEnabled.programs.zen-browser = {
    enable = true;

    profiles.default = {
      extensions.packages = with addons; [
        mal-sync
        proton-pass
        sponsorblock
        ublock-origin
        videospeed
      ];

      search = {
        force = true;
        default = "brave";
        engines =
          let
            createEngine = name: alias: url: params: {
              inherit name;
              definedAliases = [ alias ];
              urls = toList {
                template = url;
                params = attrsToList params;
              };
            };
          in
          {
            anime = createEngine "Anilist Anime" "@anime" "https://anilist.co/search/anime" {
              search = "{searchTerms}";
            };
            manga = createEngine "Anilist Manga" "@manga" "https://anilist.co/search/manga" {
              search = "{searchTerms}";
            };
            archwiki = createEngine "Arch Wiki" "@archwiki" "https://wiki.archlinux.org/index.php" {
              search = "{searchTerms}";
            };
            brave = createEngine "Brave" "@brave" "https://search.brave.com/search" { q = "{searchTerms}"; };
            flathub = createEngine "Flathub" "@flathub" "https://flathub.org/en/apps/search" {
              q = "{searchTerms}";
            };
            github = createEngine "GitHub" "@gh" "https://github.com/search" {
              type = "repositories";
              q = "{searchTerms}";
            };
            home = createEngine "Home Manager Options" "@home" "https://home-manager-options.extranix.com/" {
              query = "{searchTerms}";
              release = "master";
            };
            nix = createEngine "MyNixOS" "@nix" "https://mynixos.com/search" { q = "{searchTerms}"; };
            nixos = createEngine "NixOS Options" "@nixos" "https://search.nixos.org/options" {
              channel = "unstable";
              query = "{searchTerms}";
              sort = "relevance";
              type = "optiosn";
            };
            nixpkgs = createEngine "Nix Packages" "@nixpkgs" "https://search.nixos.org/packages" {
              channel = "unstable";
              query = "{searchTerms}";
              sort = "relevance";
              type = "packages";
            };
            wiki = createEngine "Wikipedia" "@wiki" "https://en.wikipedia.org/w/index.php" {
              search = "{searchTerms}";
              title = "Special:Search";
              profile = "advanced";
              fulltext = "1";
            };
            youtube = createEngine "YouTube" "@yt" "https://youtube.com/results" {
              search_query = "{searchTerms}";
            };
          };
      };
    };

    policies = {
      AppAutoUpdate = false;
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      BackgroundAppUpdate = false;
      BlockAboutConfig = false;
      BlockAboutProfiles = true;
      BlockAboutSupport = true;
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableProfileImport = true;
      DisableProfileRefresh = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      EnableTrackingProtection = {
        Cryptomining = true;
        EmailTracking = true;
        Fingerprinting = true;
        Locked = true;
        Value = true;
      };
      FirefoxSuggest = {
        ImproveSuggest = false;
        Locked = true;
        SponsoredSuggestions = false;
        Value = true;
        WebSuggestions = false;
      };
      GenerativeAI.Enabled = false;
      NewTabPage = true;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      PictureInPicture.Eanbled = true;
      SkipTermsOfUse = true;
      UserMessaging = {
        ExtensionRecommendations = false;
        FeatureRecommendations = false;
        FirefoxLabs = false;
        MoreFromMozilla = false;
        Locked = true;
        SkipOnboarding = true;
      };
    };
  };

}
