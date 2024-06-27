bindkey "^[[H" beginning-of-line     # Home: start of the line
bindkey "^[[F" end-of-line           # End: end of the line
bindkey "^p" history-search-backward # Ctrl+P: previous result
bindkey "^n" history-search-forward  # Ctrl+P: previous result
bindkey '^H' backward-kill-word      # Ctrl+Backspace: kill a word
bindkey '^[[3;5~' kill-word          # Ctrl+Backspace: kill a word (right side of the cursor)
bindkey "^K" forward-word            # Ctrl+K: One word forward
bindkey "^J" backward-word           # Ctrl+K: One word backward
bindkey '^[[1;5C' forward-word       # Ctrl+Right Arrow: One word forward
bindkey '^[[1;5D' backward-word      # Ctrl+Left Arrow: One word backward
