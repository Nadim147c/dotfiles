{
  inputs,
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.neovim";

  options = delib.singleEnableOption true;

  nixos.ifEnabled.environment.systemPackages = [ pkgs.neovim ];
  home.ifEnabled = {
    xdg.configFile."nvim-flake".source = "${inputs.nvim}";
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      extraWrapperArgs = [
        "--run"
        /* bash */ ''
          if [[ ! -d "$XDG_CONFIG_HOME/nvim" ]]; then
              export NVIM_APPNAME=nvim-flake
          fi
        ''
      ];
      extraPackages = with pkgs; [
        fd
        fzf
        ripgrep
        sd
      ];
    };
  };
}
