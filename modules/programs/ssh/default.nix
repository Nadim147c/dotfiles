{
  delib,
  hmlib,
  homedir,
  pkgs,
  ...
}:
delib.module {
  name = "programs.ssh";
  options = delib.singleEnableOption true;
  home.ifEnabled = {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      matchBlocks = {
        "*" = {
          forwardAgent = false;
          serverAliveInterval = 60;
          serverAliveCountMax = 3;
          identityFile = "~/.ssh/master";
        };
        "aur.archlinux.org" = {
          user = "aur";
          identityFile = "~/.ssh/aur";
          identitiesOnly = true;
        };
        "github.com" = {
          user = "git";
          identityFile = "~/.ssh/github";
          identitiesOnly = true;
        };
        "gitlab.com" = {
          user = "git";
          identityFile = "~/.ssh/gitlab";
          identitiesOnly = true;
        };
      };
    };

    home.activation.createSSHPublicKeys =
      let
        sshKeys = "aur github gitlab master";
        sshDir = "${homedir}/.ssh";
      in
      hmlib.dag.entryAfter [ "writeBoundary" ] /* bash */ ''
        for key in ${sshKeys}; do
          priv="${sshDir}/$key"
          pub="$priv.pub"

          if [ -f "$priv" ] && [ ! -f "$pub" ]; then
            ${pkgs.openssh}/bin/ssh-keygen -y -f "$priv" > "$pub"
            chmod 644 "$pub"
          fi
        done
      '';

  };
}
