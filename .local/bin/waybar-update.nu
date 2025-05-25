#!/usr/bin/env nu

def pango_style [color: string, value: string] {
    $"<span foreground=\"($color)\" font_weight=\"800\">($value)</span>"
}

def main [--update] {
    if $update {
        print $"\n  => (ansi {attr: b, fg: green})Updating system(ansi reset)\n"
        checkupdates --nosync
        paru
        return
    }

    let update = checkupdates --nocolor | lines

    if ($update | is-empty) { exit 1 }

    let tooltip = (
        $update |
        parse '{pkg} {current} -> {new}' |
        each {|it| $"($it.pkg) (pango_style "#cc0000" $it.current) -> (pango_style "#00cc00" $it.new)" } |
        str join "\n"
    )

    { text: ($update | length) tooltip: $"<big>Following updates are available: </big>\n($tooltip)" } | to json --raw
}
