{
    coreutils,
    dart-sass,
    inotify-tools,
    writeShellApplication,
    ...
}:
writeShellApplication {
    name = "compile-scss";
    runtimeInputs = [dart-sass inotify-tools coreutils];
    text = ''
        # Usage: compile-scss [--watch] path/to/file.scss
        WATCH_MODE=false

        if [ "$1" = "--watch" ]; then
            WATCH_MODE=true
            shift
        fi

        if [ "$#" -ne 1 ]; then
            echo "Usage: $0 [--watch] path/to/file.scss"
            exit 1
        fi

        INPUT="$1"

        if [ ! -f "$INPUT" ]; then
            echo "Error: File '$INPUT' does not exist."
            exit 1
        fi

        compile_scss() {
            INPUT="$1"
            DIR="$(dirname "$INPUT")"
            BASE="$(basename "$INPUT" .scss)"
            OUTPUT="$DIR/$BASE.css"
            sass --no-source-map --verbose "$INPUT":"$OUTPUT"
        }

        # Initial compilation
        compile_scss "$INPUT"

        if $WATCH_MODE; then
            echo "Watching for changes in $INPUT..."
            while true; do
                inotifywait -e close_write -e modify -e move -e create -e delete --exclude '\.css$' "$INPUT" "$(dirname "$INPUT")"
                compile_scss "$INPUT"
            done
        fi
    '';
}
