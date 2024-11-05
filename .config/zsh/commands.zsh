local commands_dir="$(dirname "$0")/commands"

for file in "$commands_dir"/*.zsh; do
	local compiled_file="${file}.zwc"

	if [[ ! -f $compiled_file || "$file" -nt "$compiled_file" ]]; then
		zcompile "$file"
	fi

	source "$file"
done
