{
    writeShellApplication,
    gitFull,
    coreutils,
    fzf,
}:
writeShellApplication {
    name = "git-sb";

    runtimeInputs = [gitFull coreutils fzf];

    text = ''
        branch=$(git branch --color)

        echo "$branch" |
            sed 's|\*| |;s|  ||' |
            fzf --ansi |
            awk '{print $1}' |
            xargs git switch
    '';
}
