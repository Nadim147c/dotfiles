{
  delib,
  pkgs,
  ...
}:
delib.script {
  name = "git-copy";
  partof = "programs.git";
  package = pkgs.writers.writeNuBin "git-copy" /* nu */ ''
    # Clone GitHub repository with proper name
    def main [
        url: string, # url of the git repository
        ...params: string # extra git options
    ] {
        let u = $url | url parse
        let p = $u | get path | path split
        let user = $p | get 1
        let repo = $p | get 2

        if ($u.host != "github.com" or $user == "Nadim147c") {
            git clone $url ...$params
            return
        }

        git clone $"git@github.com:($user)/($repo)" ...$params $"($user):($repo)"
    }
  '';
}
