#!/usr/bin/env nu

def main [] {
    let stats = (docker stats --no-stream --no-trunc --format=json | lines | each { $in | from json })

    if ($stats | is-empty) { exit 1 }

    let tooltip = (
        $stats |
        each {|it| {
            Name: ($it.Name | str replace --regex "_|-" " " | str title-case)
            Mem: $it.MemPerc
            CPU: $it.CPUPerc
        }} |
        table -i false --theme compact |
        ansi strip | lines | drop nth 0 | drop 1 | str join "\n"
    )

    let text = ($stats | length)
    { tooltip: $tooltip text: $text } | to json --raw
}
