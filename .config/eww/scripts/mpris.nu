#!/bin/env nu

def main [] {
    let format = '{{playerName}}»¦«{{title}}»¦«{{artist}}»¦«{{mpris:artUrl}}»¦«{{status}}»¦«{{position}}»¦«{{mpris:length}}'
    playerctl metadata -F -f $format | each {|data|
        let metadata = ($data | split column "»¦«" player title artist art status position length)
        print (
            $metadata |
            upsert position {|it| $it.position | into int | $in / 1000000} |
            upsert length {|it| $it.length | into int | $in / 1000000} |
            get 0 |
            to json --raw
        )
    }
}
