{delib, ...}:
delib.overlayModule {
    name = "git-isb";
    overlay = final: prev: {
        git-isb = final.writeShellApplication {
            name = "git-isb";
            runtimeInputs = with final; [gitFull coreutils fzf];
            text = ''
                git branch --color |
                  sed 's|\*| |;s|  ||' |
                  fzf --ansi |
                  awk '{print $1}' |
                  xargs git switch
            '';
        };
    };
}
