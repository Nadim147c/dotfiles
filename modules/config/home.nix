{
    delib,
    constants,
    ...
}:
delib.module {
    name = "home";

    home.always.home = let
        inherit (constants) username;
    in {
        inherit username;
        homeDirectory = "/home/${username}";
    };
}
