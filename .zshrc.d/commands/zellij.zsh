function _zellij_check() {
	if ! command -v zellij &>/dev/null; then
		echo "zellij multiplexer doesn't exists"
		return 1
	fi

	if [[ -n $ZELLIJ ]]; then
		echo "This operationg isn't allowed inside a session"
		return 1
	fi
}

alias zk='zellij kill-all-sessions --yes'

local status_path="$(dirname "$0")/.zellij_status.kdl"
ZELLIJ_STATUS_BAR=$(cat "$status_path")

function _get_zellij_layout() {
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

	format_lines='{
		cmd = "basename \"" $0 "\" | tr : -"
		cmd | getline base
		close(cmd)
		if (length(base) > max_len) { max_len = length(base) }
		files[NR] = base " " $0
	} END {
		bold_green = "\033[1;32m"
		cyan = "\033[0;36m"
		reset = "\033[0m"

		for (i = 1; i <= NR; i++) {
			split(files[i], parts, " ")
			printf "%s%-*s%s | %s%s%s\n", bold_green, max_len, parts[1], reset, cyan, parts[2], reset
		}
	}'

	directories=("$HOME/git/")
	repos=$(find "${directories[@]}" -mindepth 1 -maxdepth 1 -type d | awk "$format_lines")

	if [[ -z "$repos" ]]; then
		echo "Git directory list is empty"
		return
	fi

	selected_session=$(echo "$repos" | fzf --ansi -d' \| ' \
		--header=' Select the directory you want to attach' \
		--preview=$'git -C {2} summary | head -13 | tail +2
			eza -a --git-ignore --color=always --icons=always -w $FZF_PREVIEW_COLUMNS {2}
			eza -aT --git-ignore --color=always --icons=always -w $FZF_PREVIEW_COLUMNS {2}')

	if [[ -z "$selected_session" ]]; then return; fi

	session_name=$(echo "$selected_session" | cut -d'|' -f1 | awk '{$1=$1};1')
	selected_directory=$(echo "$selected_session" | cut -d'|' -f2- | awk '{$1=$1};1')

	layoutfile=$(_get_zellij_layout "$selected_directory")

	if zellij list-sessions --short | grep -q "^$session_name$"; then
		zellij attach "$session_name"
	else
		zellij -s "$session_name" --layout="$layoutfile"
	fi
}

function za() {

	sessions=$(zellij list-sessions --short | xargs -d'\n' printf '\033[1;32m%s\n')
	if [[ -z "$sessions" ]]; then
		echo "Sessions list is empty"
		return
	fi

	selected_directory=$(echo "$sessions" | fzf --ansi --header=' Select the zellij session you want to attach')
	[[ -n "$selected_directory" ]] && zellij attach "$selected_directory"
}

function zr() {
	_zellij_check || return

	sessions=$(zellij list-sessions --short | xargs -d'\n' printf '\033[1;32m%s\n')
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

	layoutfile=$(_get_zellij_layout "$(pwd)")

	if zellij list-sessions --short | grep -q "^$session_name$"; then
		echo "Attaching to existing session: $session_name"
		sleep 1
		zellij attach "$session_name"
	else
		zellij --session "$session_name" --layout="$layoutfile"
	fi
}
