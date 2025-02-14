#!/usr/bin/env nu

def main [] {
    let perc = (wpctl get-volume @DEFAULT_AUDIO_SINK@ | str replace 'Volume: ' '' | into float | $in * 100 | into int)

    {
        text: ($perc | to text)
        tooltip: $"Volume: ($perc)"
        percentage: $perc
    } | to json --raw
}
