{pkgs, ...}: let
    commonShellIntegration = {
        enable = true;
        enableFishIntegration = true;
        enableZshIntegration = true;
        enableBashIntegration = false;
    };

    chromashift = pkgs.callPackage ../pkgs/chromashift {};
in {
    imports = [
        ./programs/git.nix
        ./programs/yt-dlp.nix
    ];

    home.packages = with pkgs; [
        less
        nixd
        alejandra
        neovim
        gnumake
        git
        git-extras
        gallery-dl

        chromashift
        git-sb
        image-detect
        dunst-mode-cycle
    ];

    home.sessionVariables = {
        LS_COLORS = "$(${pkgs.vivid}/bin/vivid generate catppuccin-mocha)";
    };

    home.file.".config/npm/npmrc".text = ''
        prefix=$\{XDG_DATA_HOME}/npm
        cache=$\{XDG_CACHE_HOME}/npm
        init-module=$\{XDG_CONFIG_HOME}/npm/config/npm-init.js
        logs-dir=$\{XDG_STATE_HOME}/npm/logs
        color=true
    '';

    home.file.".config/zellij".source = ../config/zellij;

    programs.zsh = {
        enable = true;
        enableCompletion = true;
    };
    programs.bash.enable = true;
    programs.fish = {
        enable = true;
        shellInit = builtins.readFile ../config/fish/config.fish;
        interactiveShellInit = "${chromashift}/bin/cshift alias fish | source";
    };

    home.file.".config/starship.toml".source = ../config/starship/starship.toml;
    home.file.".config/atuin/config.toml".source = ../config/atuin/config.toml;
    programs.starship = commonShellIntegration;
    programs.carapace = commonShellIntegration;
    programs.mise = commonShellIntegration;
    programs.atuin = commonShellIntegration;

    programs.zoxide = {
        enable = true;
        enableFishIntegration = true;
        enableZshIntegration = true;
        enableBashIntegration = false;
        options = ["--cmd=cd"];
    };

    programs.eza = {
        enable = true;
        enableFishIntegration = true;
        enableZshIntegration = true;
        enableBashIntegration = false;
        icons = "auto";
    };

    programs.bat = {
        enable = true;
        extraPackages = with pkgs.bat-extras; [batman];
    };
}
