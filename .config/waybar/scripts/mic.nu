#!/usr/bin/env nu

def main [--toggle] {
    let microphones = (pactl --format json list sources | from json | where properties."device.class" == sound)
    mut microphones_filtered = ($microphones | where state == RUNNING)

    mut microphone = ($microphones | first)

    if ($microphones_filtered | is-not-empty) {
        $microphone = ($microphones_filtered | first)
    } else {
        $microphone = ($microphones | first)
    }

    if $microphone == null {
        error make -u { msg: "No microphone found" }
    }

    if $toggle {
        pactl set-source-mute $microphone.name toggle
        killall -SIGRTMIN4 waybar
        return
    }

    if ($microphone.state != RUNNING) and (not $microphone.mute) {
        exit
    }

    let alt = if ($microphone | get mute) { "muted" } else { "normal" }

    mut output = {
        alt: $alt
        text: ($microphone | get state | str downcase),
        tooltip: ($microphone | get description)
        percentage: ($microphone | get base_volume.value_percent | str replace "%" "" | into int)
    }

    $output | to json --raw
}
