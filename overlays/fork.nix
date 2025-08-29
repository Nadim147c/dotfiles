{delib, ...}:
delib.overlayModule {
    name = "fork";
    overlay = final: prev: {
        fork = final.writeShellApplication {
            name = "fork";
            runtimeInputs = with final; [uwsm];
            text = ''
                #!/usr/bin/env bash
                set -euo pipefail

                if [ $# -eq 0 ]; then
                  echo "Usage: fork <executable|entry.desktop[:action]> [args...]" >&2
                  exit 1
                fi

                # Fork a new process that runs uwsm with the given args
                (
                  setsid uwsm app -- "$@" >/dev/null 2>&1 &
                  disown
                ) &
                exit 0
            '';
        };
    };
}
