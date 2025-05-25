#!/usr/bin/env nu

def main [] {
    let stats = (docker stats --no-stream --no-trunc --format=json | lines | each { $in | from json })
    let tooltip = (
        $stats |
        each {|it| {
            Name: ($it.Name | str replace "_" " " | str title-case)
            Mem: $it.MemPerc
            CPU: $it.CPUPerc
        }} |
        table -i false |
        ansi strip |
        str trim
    )

    let text = ($stats | length)
    { tooltip: $tooltip text: $text } | to json --raw
}
