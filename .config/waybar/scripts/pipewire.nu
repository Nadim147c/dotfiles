#!/usr/bin/env nu

def main [] {
    let info = (wpctl get-volume @DEFAULT_AUDIO_SINK@ | split words)
    let perc = ($info.2 | into int)
    let class = if (($info | length) == 4) and ($info.3 == MUTED) {
        "muted"
    } else {
        "normal"
    }

    {
        text: ($perc | to text)
        tooltip: $"Volume: ($perc)"
        class: $class
        alt: $class
        percentage: $perc
    } | to json --raw
}
