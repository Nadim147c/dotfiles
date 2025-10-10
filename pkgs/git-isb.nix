{
    coreutils,
    fzf,
    git,
    writeShellApplication,
    ...
}:
writeShellApplication {
    name = "git-isb";
    runtimeInputs = [
        coreutils
        fzf
        git
    ];
    text = ''
        git branch --color |
            sed 's|\*| |;s|  ||' |
            fzf --ansi |
            awk '{print $1}' |
            xargs git switch
    '';
}
