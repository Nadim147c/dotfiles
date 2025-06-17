#!/usr/bin/nu

def workspace [input_id?: int] {
    let id = if $input_id == null {
        hyprctl activeworkspace -j | from json | get id
    } else { $input_id }

    hyprctl workspaces -j
        | from json
        | select id name lastwindowtitle
        | rename id name hover
        | sort-by id
        | upsert active {|ws| $ws.id == $id}
}

def main [] {
    let workspaces = workspace
    print ($workspaces | to json --raw)


    let uri = $"UNIX-CONNECT:($env.XDG_RUNTIME_DIR)/hypr/($env.HYPRLAND_INSTANCE_SIGNATURE)/.socket2.sock"
    socat -U - $uri | lines | each {|line|
        if $line starts-with "workspacev2>>" {
            print --stderr $line
            let id = ($line | parse `workspacev2>>{id},{name}` | get 0.id | into int)
            let workspaces = workspace $id
            print ($workspaces | to json --raw)
        }
    }
}
