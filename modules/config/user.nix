{
    constants,
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

    nixos.always = {
        programs.zsh.enable = true;
        users = {
            groups.${constants.username} = {};
            users.${constants.username} = {
                shell = pkgs.zsh;
                isNormalUser = true;
                description = constants.fullname;
                extraGroups = ["networkmanager" "wheel" "docker"];
            };
        };
    };
}
