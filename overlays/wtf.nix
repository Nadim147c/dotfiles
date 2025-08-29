{delib, ...}:
delib.overlayModule {
    name = "wtf";
    overlay = final: prev: {
        wtf = final.writeShellApplication {
            name = "wtf";
            runtimeInputs = with final; [ripgrep coreutils man];
            text = ''
                if [ $# -lt 2 ] || [ "$1" != "is" ]; then
                  echo "Usage: wtf is <query>" >&2
                  exit 1
                fi

                shift  # drop "is"
                query=$(printf "%s-" "$@" | sed 's/-$//')

                man -k "$query" | rg "^$query" | head -n1 | sed 's|\s\+| |' | xargs echo
            '';
        };
    };
}
