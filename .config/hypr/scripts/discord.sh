#!/bin/sh

command="vesktop"
title="Discord"

hyprctl dispatch -- exec '[workspace 3 slient]' "$command"

while ! hyprctl clients | grep -Fq "title: $title"; do
    sleep 0.05
done

hyprctl dispatch -- movetoworkspacesilent "3,title:^($title)$"
