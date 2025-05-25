alias n=pnpm
alias pm=pm2
alias yt=yt-dlp
alias sedit=sudoedit

alias -g -- outnull="&>/dev/null"

alias delta='delta --line-numbers --hunk-header-decoration-style none'
alias ffmpeg='ffmpeg -hide_banner'

alias temp='cd "$(mktemp -d)"'

alias pyvenv='python3 -m venv .venv'
alias stdn='sudo shutdown now'
alias start="xdg-open"
alias s.="xdg-open ."
alias lines=$'printf \'%s\\n\''
alias ff='clear && fastfetch'

alias e='eza --icons'
alias ls='eza --icons'
alias ll='eza --icons --long'
alias l='eza --color=always --icons -ialh'
alias la='eza --color=always --icons -ia'
alias tree='eza --color=always --icons=always -ia --tree --git-ignore | less -r -F'

# CD
alias rd='cd -' # Return to previous directory
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# GNU coreutils
man() { batman "$@"; }
alias rm='rm -vI'
alias cp='cp -vi'
alias mv='mv -vi'
alias df='df -h'
alias du='du -h'
alias grep='grep --color'
alias less='less -r -F'
alias mkdir='mkdir -pv'
alias xa="xargs -rd'\\n'"
alias xa1="xargs -rd'\\n' -n1"
alias dsc=$'dfc -c always 2>/dev/null | rg \'FILESYSTEM|^/dev/\\w+\''

# Fix ssh weirdness with kitty
[[ $TERM == "xterm-kitty" ]] && alias ssh="kitty +kitten ssh"

# Sync dotfiles using GNU stow
alias dotsync='stow -d ~/git/dotfiles/ -t ~/ .'

# Git
alias g=git
alias ga='git add'
alias gpl='git pull'
alias gph='git push'
alias gr='git reset'
alias gcm='git commit'
alias gaa='git add .'
alias gt='git status'
alias gd='git diff'

alias gpr='git pull --rebase'
alias gst='git status'

alias grh='git reset --hard'
alias grs='git reset --soft'
alias grhh='git reset --hard HEAD'
alias grsh='git reset --soft HEAD'
