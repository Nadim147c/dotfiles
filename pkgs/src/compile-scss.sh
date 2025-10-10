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

compile_scss() {
    INPUT="$1"
    DIR="$(dirname "$INPUT")"
    BASE="$(basename "$INPUT" .scss)"
    OUTPUT="$DIR/$BASE.css"
    gum log --level info --prefix scss "$INPUT"
    sass --no-source-map --verbose "$INPUT":"$OUTPUT"
}

compile_all_scss() {
    find "$@" -iname '*.scss' | while IFS=$'\n' read -r FILE; do
        compile_scss "$FILE"
    done
}

compile_all_scss "$@"

if $WATCH_MODE; then
    echo "Watching for changes in ${INPUT[*]}..."
    while true; do
        inotifywait -e close_write -e modify -e move -e create -e delete --exclude '\.css$' "$@"
        compile_all_scss "$@"
    done
fi
