#!/usr/bin/env nu

def main [
    --greet # Get user name
    --player # Get player info
] {
    if $greet {
        print $"Hello, (whoami | str title-case)"
        return
    }

    if $player {
        let infos = (
            playerctl -a metadata --format="{{playerName}}»¦«{{title}}»¦«{{artist}}" |
            lines |
            split column '»¦«' player title artist
        )

        mut $info = ($infos | first)

        if ($infos | where player =~ spotify | is-not-empty) {
            $info = ($infos | where player =~ spotify | first)
        }

        if $info == null {
            return
        }

        let icon = match $info.player {
            spotify => "󰓇  " ,
            YoutubeMusic => "󰗃  "
             _ => "",
        }

        print $"($icon)($info.artist) - ($info.title)"
        return
    }
}
