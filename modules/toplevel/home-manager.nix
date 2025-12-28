{
  config,
  delib,
  homeManagerUser,
  inputs,
  moduleSystem,
  pkgs,
  ...
}:
delib.module {
  name = "home-manager";

  myconfig.always.args.shared =
    let
      home = if moduleSystem == "home" then config else config.home-manager.users.${homeManagerUser};
    in
    {
      inherit home;
      inherit (home) xdg;
      homedir = home.home.homeDirectory;
      hmlib = inputs.home-manager.lib.hm;
    };

  nixos.always = {
    environment.systemPackages = [ pkgs.home-manager ];
    home-manager = {
      useUserPackages = true;
      backupFileExtension = "home.bak";
    };
  };
}
