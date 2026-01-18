{
  constants,
  config,
  delib,
  inputs,
  homedir,
  pkgs,
  xdg,
  ...
}:
let
  inherit (constants) username;
  user = {
    owner = username;
    mode = "0600";
  };
  mkSSHKey = name: { path = "${homedir}/.ssh/${name}"; } // user;
in
delib.module {
  name = "sops";

  options = delib.singleEnableOption true;

  nixos.always.imports = [ inputs.sops-nix.nixosModules.sops ];
  nixos.ifEnabled = {
    environment.systemPackages = with pkgs; [
      age
      sops
    ];

    fileSystems."/home".neededForBoot = true;
    sops = {
      defaultSopsFile = ../../secrets/secrets.yaml;
      defaultSopsFormat = "yaml";
      age.keyFile = "${xdg.configHome}/sops/age/keys.txt";
      secrets = {
        password = { };
        "rclone/gdrive/id" = user;
        "rclone/gdrive/secret" = user;
        "rclone/gdrive/token" = user;
        "rclone/crypt/pass" = user;
        "rclone/crypt/salt" = user;
        "ssh/aur" = mkSSHKey "aur";
        "ssh/github" = mkSSHKey "github";
        "ssh/gitlab" = mkSSHKey "gitlab";
        "ssh/master" = mkSSHKey "master";
      };
    };

    users.users.${username} = {
      isNormalUser = true;
      hashedPasswordFile = config.sops.secrets.password.path;
    };
  };
}
