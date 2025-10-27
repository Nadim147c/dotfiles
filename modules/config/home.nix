{
    delib,
    constants,
    pkgs,
    ...
}:
delib.module {
    name = "home";

    home.always. home = let
        inherit (constants) username;
    in {
        inherit username;
        homeDirectory =
            if pkgs.stdenv.isDarwin
            then "/Users/${username}"
            else "/home/${username}";
    };
}
