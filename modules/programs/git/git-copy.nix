{
    delib,
    pkgs,
    ...
}:
delib.script {
    name = "git-copy";
    package = pkgs.writers.writeNuBin "git-copy" # nu

    ''
        # Clone GitHub repository with proper name
        def main [
            url: string, # url of the git repository
            ...params: string # extra git options
        ] {
            let u = $url | url parse
            if $u.host != "github.com" {
                git clone $url ...$params
                return
            }

            let p = $u | get path | path split
            let user = $p | get 1
            let repo = $p | get 2
            git clone $"git@github.com:($user)/($repo)" ...$params $"($user):($repo)"
        }
    '';
}
