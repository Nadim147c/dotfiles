#!/usr/bin/bash

trap 'kill $(jobs -p) 2>/dev/null' EXIT

fzf_source() {
    cliphist list | rg '(\d+)\t(.*)' --replace $'\e[1;31m$1\e[0m:'$'\e[1;32m$2\e[0m'
}

# Use fzf to select from cliphist
selected=$(
    fzf_source | fzf -d: \
        --preview 'echo {} | rg -q "\[\[ binary data .+ .+ (png|jpeg|jpg|webm) \d+x\d+ \]\]" &&
cliphist decode {1} | kitten icat --clear --silent --transfer-mode=memory --unicode-placeholder --stdin=yes --place="${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}@0x0" ||
cliphist decode {1} | bat --color=always -p' \
        --ansi --no-border --no-sort --reverse --preview-border=none \
        --bind "ctrl-x:execute(echo {1} | cliphist delete)+exclude"
)

# Copy selected entry
if [[ -n "$selected" ]]; then
    id=$(echo "$selected" | cut -d: -f1)
    cliphist decode "$id" | wl-copy
    echo "Copied entry ID $id to clipboard."
fi

pid=$(hyprctl clients -j | jq -r '.[] | select(.class == "clipboard") | .pid')
[[ -n "$pid" ]] && kill -9 "$pid"
