{
    config,
    delib,
    homeManagerUser,
    moduleSystem,
    pkgs,
    ...
}:
delib.module {
    name = "home-manager";

    myconfig.always.args.shared = let
        home =
            if moduleSystem == "home"
            then config
            else config.home-manager.users.${homeManagerUser};
    in {
        home = home;
        xdg = home.xdg;
    };

    nixos.always = {
        environment.systemPackages = [pkgs.home-manager];
        home-manager = {
            useUserPackages = true;
            backupFileExtension = "home.bak";
        };
    };
}
