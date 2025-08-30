{
    delib,
    pkgs,
    ...
}:
delib.module {
    name = "user";

    home.always = {
        nixpkgs.config.allowUnfree = true;
        programs.home-manager.enable = true;
    };

    nixos.always = {myconfig, ...}: let
        inherit (myconfig.constants) username userfullname;
    in {
        programs.zsh.enable = true;
        users = {
            groups.${username} = {};

            users.${username} = {
                shell = pkgs.zsh;
                isNormalUser = true;
                description = userfullname;
                extraGroups = ["networkmanager" "wheel"];
            };
        };
    };
}
