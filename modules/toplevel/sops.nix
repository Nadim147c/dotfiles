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
  mkSSHKey = name: {
    owner = username;
    mode = "0600";
    path = "${homedir}/.ssh/${name}";
  };
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
