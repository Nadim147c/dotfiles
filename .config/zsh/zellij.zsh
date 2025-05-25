alias zk='zellij kill-all-sessions --yes'

function _zellij_zoxide_add() {
	[[ ! $commands[zoxide] ]] && return 1
	zoxide add "$1"
}

function _zellij_check() {
	if [[ ! $commands[zellij] ]]; then
		echo "zellij multiplexer doesn't exists"
		return 1
	fi

	if [[ -n $ZELLIJ ]]; then
		echo "This operationg isn't allowed inside a session"
		return 1
	fi
}


local status_path="$HOME/.config/zellij/status.kdl"
ZELLIJ_STATUS_BAR=$(cat "$status_path")

function _zellij_get_layout() {
	local layoutfile=$(mktemp)
	echo "layout {
		cwd \"$1\"
		tab name=\"Neovim\" focus=true hide_floating_panes=true {
			pane command=\"nvim\" cwd=\"$1\"
		}
		tab name=\"Shell\" hide_floating_panes=true {
			pane cwd=\"$1\"
		}
		default_tab_template {
			$ZELLIJ_STATUS_BAR
			children
		}
	}" >"$layoutfile"
	echo -n "$layoutfile"
}

function zc() {
	_zellij_check || return

	repos=$(printf '%s\n' "$HOME/git"/*/ | xargs -d'\n' -I {} sh -c $'printf \'\e[1;32m%s\e[0m\n\' $(basename "{}")')

	if [[ -z "$repos" ]]; then
		echo "Git directory list is empty"
		return
	fi

	selected_name=$(echo "$repos" | fzf --ansi --preview='cd "$HOME/git/"{};fd --hidden --exclude=.git --color=always')

	[[ -z "$selected_name" ]] && return 1

	session_name="$selected_name"
	selected_directory="$HOME/git/$selected_name"

	_zellij_zoxide_add "$selected_directory"

	layoutfile=$(_zellij_get_layout "$selected_directory")

	sessions=("${(@f)$(zellij list-sessions --short)}")
	if (( ${#sessions[(r)$session_name]} )); then
		zellij attach "$session_name"
	else
		zellij -s "$session_name" -n "$layoutfile"
	fi
}

function za() {
	_zellij_check || return

	sessions=$(zellij list-sessions --short | sort | xargs -d'\n' printf '\033[1;32m%s\n')
	if [[ -z "$sessions" ]]; then
		echo "Sessions list is empty"
		return
	fi

	selected_session=$(echo "$sessions" | fzf --ansi --header=' Select the zellij session you want to attach')
	[[ -n "$selected_session" ]] && zellij attach "$selected_session"
}

function zr() {
	if [[ ! $commands[zellij] ]]; then
		echo "zellij multiplexer doesn't exists"
		return 1
	fi

	sessions=$(zellij list-sessions --short | sort | xargs -d'\n' printf '\033[1;32m%s\n')
	if [[ -z "$sessions" ]]; then
		echo "Sessions list is empty"
		return
	fi

	selected_directory=$(echo "$sessions" | fzf --ansi --header=' Select the zellij session you want to delete')
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

	_zellij_zoxide_add "$(pwd)"

	layoutfile=$(_zellij_get_layout "$(pwd)")

	sessions=("${(@f)$(zellij list-sessions --short)}")
	if (( ${#sessions[(r)$session_name]} )); then
		echo "Attaching to existing session: $session_name"
		sleep 1
		zellij attach "$session_name"
	else
		zellij -s "$session_name" -n "$layoutfile"
	fi
}
