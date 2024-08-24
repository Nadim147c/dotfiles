function custom-kill-word() {
    local CURSOR_POS=$CURSOR
    local CHAR_BEFORE_CURSOR=${BUFFER[CURSOR - 1]}
    local pattern='[[:alnum:]]'
    local space_pattern='[[:space:]]'
    if [[ $CHAR_BEFORE_CURSOR =~ $pattern ]]; then
        while [[ $CURSOR -gt 1 && ${BUFFER[CURSOR - 1]} =~ $pattern ]]; do
            CURSOR=$((CURSOR - 1))
        done
        BUFFER="${BUFFER[1, CURSOR - 1]}${BUFFER[CURSOR_POS + 1, -1]}"
        CURSOR=$CURSOR_POS
    elif [[ $CHAR_BEFORE_CURSOR =~ $space_pattern ]]; then
        while [[ $CURSOR -gt 1 && ${BUFFER[CURSOR - 1]} =~ $space_pattern ]]; do
            CURSOR=$((CURSOR - 1))
        done
        BUFFER="${BUFFER[1, CURSOR - 1]}${BUFFER[CURSOR_POS + 1, -1]}"
        CURSOR=$CURSOR_POS
    else
        BUFFER="${BUFFER[1, CURSOR - 1]}${BUFFER[CURSOR_POS + 1, -1]}"
    fi
}

function custom-kill-word-forward() {
    local pattern='[[:alnum:]]'
    local space_pattern='[[:space:]]'
    local BUFLEN=${#BUFFER}
    local CHAR_AFTER_CURSOR=${BUFFER[CURSOR]}
    if [[ $CHAR_AFTER_CURSOR =~ $pattern ]]; then
        while [[ $CURSOR -le $BUFLEN && ${BUFFER[CURSOR]} =~ $pattern ]]; do
            CURSOR=$((CURSOR + 1))
        done
        BUFFER="${BUFFER[1, CURSOR - 1]}${BUFFER[CURSOR, -1]}"
    elif [[ $CHAR_AFTER_CURSOR =~ $space_pattern ]]; then
        while [[ $CURSOR -le $BUFLEN && ${BUFFER[CURSOR]} =~ $space_pattern ]]; do
            CURSOR=$((CURSOR + 1))
        done
        BUFFER="${BUFFER[1, CURSOR - 1]}${BUFFER[CURSOR, -1]}"
    else
        BUFFER="${BUFFER[1, CURSOR - 1]}${BUFFER[CURSOR + 1, -1]}"
    fi
}

zle -N custom-kill-word
zle -N custom-kill-word-forward

bindkey '^h' custom-kill-word              # Ctrl+Backspace: kill a word
bindkey '\e[3;5~' custom-kill-word-forward # Ctrl+Backspace: kill a word (right side of the cursor)
bindkey "^[[H" beginning-of-line           # Home: start of the line
bindkey "^[[F" end-of-line                 # End: end of the line
bindkey "^p" history-search-backward       # Ctrl+P: previous result
bindkey "^n" history-search-forward        # Ctrl+P: previous result
bindkey "^K" forward-word                  # Ctrl+K: One word forward
bindkey "^J" backward-word                 # Ctrl+K: One word backward
bindkey '^[[1;5C' forward-word             # Ctrl+Right Arrow: One word forward
bindkey '^[[1;5D' backward-word            # Ctrl+Left Arrow: One word backward
