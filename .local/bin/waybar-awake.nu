#!/usr/bin/env nu

def main [
    --check # Checks if stay-awake is enabled or not
    --toggle # Toggle stay-awake
] {
    let path = "/tmp/stay-awake"

    if $check {
        if (echo $path | path exists) {
            exit 1
        } else {
            exit
        }
    }

    if $toggle {
        if (echo $path | path exists) {
            rm -vf $path
        } else {
            touch $path
        }
    }
}
