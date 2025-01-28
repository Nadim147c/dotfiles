#!/bin/env nu

def main [] {
    def _format_timestamp [us: int] {
        let seconds = ($us / 1000000)
        let hours = ($seconds // 3600)
        let minutes = (($seconds mod 3600) // 60)
        let seconds = ($seconds // 60)

        echo ({
            seconds: $seconds
            hours: $hours
            minutes: $minutes
        })

        if $hours != 0 {
            $"($hours | fill -w 2 -c 0 -a r):($minutes | fill -w 2 -c 0 -a r):($seconds | fill -w 2 -c 0 -a r)"
        } else {
            $"($minutes | fill -w 2 -c 0 -a r):($seconds | fill -w 2 -c 0 -a r)"
        }
    }

    let format = '{{playerName}}»¦«{{title}}»¦«{{artist}}»¦«{{mpris:artUrl}}»¦«{{status}}»¦«{{position}}»¦«{{mpris:length}}'
    playerctl metadata -F -f $format | each {|data|
        let metadata = ($data | split column "»¦«" player title artist art status position length)
        print ($metadata |
            into int length |
            into int position |
            get 0 |
            to json --raw
        )
    }
}
