#!/usr/bin/env nu

def main [] {
    let stats = docker ps --format=json | lines | each { $in | from json }

    if ($stats | is-empty) { exit 1 }

    let tooltip = ($stats |
        select Names Status |
        upsert Names {|it| $it.Names | str replace --regex  "_|-" " " | str title-case } |
        sort-by Names |
        table --index false --theme psql |
        ansi strip |
        str trim --right
    )
    {
        text: ($stats | length)
        tooltip: $tooltip
    } | to json --raw
}
