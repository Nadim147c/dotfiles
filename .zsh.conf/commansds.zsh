_COMMAND_DIR="$(dirname "$0")/commands"

for COMMAND_FILE in "$_COMMAND_DIR"/*.zsh; do
	source $COMMAND_FILE
done
