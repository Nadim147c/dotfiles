#!/usr/bin/env nu

def main [
    --cancel (-c) = "Cancel": string
    --okay (-o) = "Confirm": string
    --description (-d) = "Would like to continue": string
    callback = "echo confirmed": string
] {
    (
        eww open confirm
        --arg $"cancel=($cancel)"
        --arg $"okay=($okay)"
        --arg $"decs=($description)"
        --arg $"callback=($callback)"
    )
}
