{
    delib,
    inputs,
    pkgs,
    ...
}:
delib.module {
    name = "home";

    home.always = {myconfig, ...}: let
        inherit (myconfig.constants) username;
    in {
        imports = [inputs.rong.homeModules.default];
        home = {
            inherit username;
            homeDirectory =
                if pkgs.stdenv.isDarwin
                then "/Users/${username}"
                else "/home/${username}";
        };
    };
}
