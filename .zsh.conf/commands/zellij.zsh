function _zellij_check() {
	if ! command -v zellij --help &>/dev/null; then
		echo "zellij multiplexer doesn't exists"
		return 1
	fi

	if [[ -n $ZELLIJ ]]; then
		echo "This operationg isn't allowed inside a session"
		return 1
	fi
}

function zc() {
	_zellij_check || return

	directories=("$HOME/git/" "$HOME/tools/")

	repos=$(find "${directories[@]}" -mindepth 1 -maxdepth 1 -type d \
		-exec sh -c $'printf "\e[1;32m%s\e[0m:\e[1;36m%s\e[0m\n" "$(basename "{}")" "{}"' $';')

	if [[ -z "$repos" ]]; then
		echo "Git directory list is empty"
		return
	fi

	selected_session=$(echo "$repos" | fzf --ansi -d: \
		--header=' Select the directory you want to attach' \
		--preview=$'git -C {2} summary | head -13 | tail +2
			eza -a --git-ignore --color=always --icons=always -w $FZF_PREVIEW_COLUMNS {2}
			eza -aT --git-ignore --color=always --icons=always -w $FZF_PREVIEW_COLUMNS {2}')

	if [[ -z "$selected_session" ]]; then return; fi

	session_name=$(echo "$selected_session" | cut -d: -f1)
	selected_directory=$(echo "$selected_session" | cut -d: -f2-)

	sessions=$(zellij list-sessions --no-formatting)

	cd "$selected_directory"

	if echo "$sessions" | grep -q "$session_name"; then
		zellij attach "$session_name"
	else
		zellij -s "$session_name"
	fi
}

function za() {
	_zellij_check || return

	sessions=$(zellij list-sessions)
	if [[ -z "$sessions" ]]; then
		echo "Sessions list is empty"
		return
	fi

	selected_directory=$(echo "$sessions" | fzf --ansi --header=' Select the zellij session you want to attach' | cut -d' ' -f1)
	[[ -n "$selected_directory" ]] && zellij attach "$selected_directory"
}

function zr() {
	_zellij_check || return

	sessions=$(zellij list-sessions)
	if [[ -z "$sessions" ]]; then
		echo "Sessions list is empty"
		return
	fi

	selected_directory=$(echo "$sessions" | fzf --ansi --header=' Select the zellij session you want to delete' | cut -d' ' -f1)
	[[ -n "$selected_directory" ]] && zellij delete-session --force "$selected_directory"
}

function zn() {
	_zellij_check || return

	if [[ -n $1 ]]; then
		session_name = "$1"
	else
		default_name=$(basename "$(pwd)" | tr . _)
		echo -n " What is the name of the session (Default: $default_name): "
		read session_name
		[[ -z "$session_name" ]] && session_name="$default_name"
	fi

	if zellij list-sessions --no-formatting | grep -q "$session_name"; then
		echo "Attaching to existing session: $session_name"
		sleep 1
		zellij attach "$session_name"
	else
		zellij --session "$session_name"
	fi
}
