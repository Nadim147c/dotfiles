{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "wordlist";
  options = delib.singleEnableOption host.hackingFeatured;
  nixos.ifEnabled.environment.wordlist = {
    enable = true;
    lists = {
      WORDLIST = [ "${pkgs.scowl}/share/dict/words.txt" ];
      AUGMENTED_WORDLIST = [
        "${pkgs.scowl}/share/dict/words.txt"
        "${pkgs.scowl}/share/dict/words.variants.txt"
      ];
    };
  };
}
