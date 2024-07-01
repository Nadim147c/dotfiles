COMMAND_DIR="$(dirname $0)/commands"

for COMMAND_FILE in $COMMAND_DIR/*.zsh; do
	source $COMMAND_FILE
done
