let zellij_status_bar = (open ~/.config/zellij/status.kdl)

def "error message" [msg: string] {
    error make --unspanned { msg: $msg }
}

def _zellij_zoxide_add [path: string] {
    if (which zoxide | length) > 0 {
        zoxide add $path
    }
}

def _zellij_check [] {
    if (which zellij | length) == 0 {
        error message "zellij multiplexer doesn't exist"
    }

    if "ZELLIJ" in $env {
        error message "This operation isn't allowed inside a session"
    }
}

def _zellij_get_layout [cwd: string] {
    let status_path = ($env.HOME | path join ".config/zellij/status.kdl")
    let status_bar = (cat $status_path)

    let layout = (echo $"
    layout {
        cwd \"($cwd)\"
        tab name=\"Neovim\" focus=true hide_floating_panes=true {
            pane command=\"nvim\" cwd=\"($cwd)\"
        }
        tab name=\"Shell\" hide_floating_panes=true {
            pane cwd=\"($cwd)\"
        }
        default_tab_template {
            ($status_bar)
            children
        }
    }
")

    let file = (mktemp -t)
    $layout | save -f $file

    return $file
}

def zk [] { zellij kill-all-sessions --yes }

def zc [] {
    _zellij_check

    let projects = [
        $"($env.HOME)/git"
    ]
    let repos = (fd . ~/git --color=always --max-depth 1 --min-depth 1 | lines |
        str replace $env.HOME $"(ansi red)~(ansi blue)")

    if ($repos | is-empty) {
        error message "Git directory list is empty"
    }

    let selected = ($repos | to text | fzf --ansi --preview $"sh -c 'tree -C --gitignore {}'")

    if $selected == null {
        error message "No Session selected"
    }

    let name = ($selected | path basename | str replace --regex "\\.| " "-")

    let directory = ($selected | path expand)

    _zellij_zoxide_add $directory

    let layoutfile = (_zellij_get_layout $directory)

    let sessions = (zellij list-sessions --short | lines)
    if $name in $sessions {
        zellij attach $name
    } else {
        zellij -s $name -n $layoutfile
    }
}

def zr [] {
    zellij_check

    let sessions = (zellij list-sessions --short | lines | sort)

    if ($sessions | is-empty) {
        echo "Sessions list is empty"
        return
    }

    $sessions | fzf --ansi --header --multi " Select the zellij session you want to delete" | lines | each {|session|
        zellij delete-session --force $session
    }
}

def zn [] {
    _zellij_check

    let default_name = (pwd | path basename | str replace --regex "\\.| " "_")

    let name = (input -d $default_name "What is the name of the session? ")

    _zellij_zoxide_add (pwd)

    let layoutfile = (_zellij_get_layout (pwd))

    let sessions = (zellij list-sessions --short | lines)

    if $name in $sessions {
        zellij attach $name
    } else {
        zellij -s $name -n $layoutfile
    }
}

