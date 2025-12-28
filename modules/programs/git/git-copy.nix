{
  delib,
  pkgs,
  ...
}:
let
  url-parser = pkgs.writers.writeNu "git-copy-nu" /* nu */ ''
    def getpath [u: string] {
      $u | path split | skip 1 | first 2 | str join /
    }

    def main [u: string] {
      let url = $u | url parse
      let host = $url.host

      let out = match $host {
        github.com | gitlab.com => {
          let path = getpath $url.path
          echo ({
            url: $"git@($host):($path)"
            path: $path
          })
        }
        aur.archlinux.org => {
          let path = $url.path | path split | last | str replace --regex '.git$' ""
          echo ({
            url: $"ssh://aur@($host)/($path).git"
            path: $"aur/($path)"
          })
        }
        _ => {
          error make -u { msg: "Unsupported url host. use `git clone <url>` instead!" }
        }
      }
      return ($out | to json --raw)
    }
  '';
in
delib.script rec {
  name = "git-copy";
  partof = "programs.git";
  package = pkgs.writeShellScriptBin name /* nu */ ''
    if [[ $# -eq 0 ]]; then
        echo "Use: ${name} <url> ...<git-flags>" >&2
        exit 1
    fi

    url=$(${url-parser} "$1")
    shift

    uri=$(echo "$url" | jq -r .url)
    dir=$(echo "$url" | jq -r .path)

    username=$(gh auth status --active --jq '.[][][].login' --json hosts || echo "")
    if [[ -n "$username" ]]; then
        dir=$(echo "$dir" | sed "s|$username/||")
    fi

    git clone "$uri" "$HOME/git/$dir" "$@"
  '';
}
