# overlays/git-sb.nix
final: prev: {
    git-sb = prev.writeShellApplication {
        name = "git-sb";

        runtimeInputs = with final; [git coreutils fzf];

        text = ''
            branch=$(git branch --color)

            echo "$branch" |
                sed 's|\*| |;s|  ||' |
                fzf --ansi |
                awk '{print $1}' |
                xargs git switch
        '';
    };
}
