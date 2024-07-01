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

function za() {
	_zellij_check || return

	SESSIONS=$(zellij list-sessions)
	if [[ -z $SESSIONS ]]; then
		echo "Sessions list is emty"
		return
	fi

	SELECTED_SESSION=$(echo $SESSIONS | fzf --ansi --header=' Select the zellij session you want attach' | cut -d' ' -f1)
	[[ -n $SELECTED_SESSION ]] && zellij attach $SELECTED_SESSION
}

function zr() {
	_zellij_check || return

	SESSIONS=$(zellij list-sessions)
	if [[ -z $SESSIONS ]]; then
		echo "Sessions list is emty"
		return
	fi

	SELECTED_SESSION=$(echo $SESSIONS | fzf --ansi --header=' Select the zellij session you want delete' | cut -d' ' -f1)
	[[ -n $SELECTED_SESSION ]] && zellij delete-session --force $SELECTED_SESSION
}

function zn() {
	_zellij_check || return

	if [[ -n $1 ]]; then
		session_name = $1
	else
		default_name=$(basename $(pwd) | tr . _)
		echo -n " What is the name of the session (Default: $default_name): "
		read session_name
		[[ -z $session_name ]] && session_name=$default_name
	fi

	session_exist=$(zellij ls -n | grep -o $session_name)
	if [[ -n $session_exist ]]; then
		echo "Attaching to existing session: $session_name"
		sleep 1
		zellij attach $session_name
	else
		zellij --session $session_name
	fi
}
