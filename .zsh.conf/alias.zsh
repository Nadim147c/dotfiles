alias vim=nvim
alias n=pnpm
alias pm=pm2
alias yt=yt-dlp
alias sedit=sudoedit
alias kys=exit

alias -g -- outnull="&>/dev/null"

alias delta='delta --line-numbers --hunk-header-decoration-style none'
alias ffmpeg='ffmpeg -hide_banner'
alias pyvenv='python3 -m venv .venv'
alias reload='clear && source ~/.zshrc'
alias stdn='sudo shutdown now'
alias start="xdg-open"
alias s.="xdg-open ."
alias lines=$'printf \'%s\\n\''
alias files=$'fd --type f . --'

# LS alias
alias ls='eza --icons'
alias l='eza --color=always --icons -ialh'
alias la='eza --color=always --icons -ia'
alias tree='eza --color=always --icons=always -ia --tree --git-ignore | less -r -F'

# CD
alias rd='cd -' # Return to previous directory
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Bat and Bat-extra
alias cat=bat
alias man=batman
alias diff=batdiff

# GNU coreutils
alias cp='cp -iv'
alias rm='rm -Iv'
alias mv='mv -iv'
alias du='du -h'
alias less='less -r -F'
alias mkdir='mkdir -pv'
alias xa='xargs -d "\n"'

# Fix ssh weirdness with kitty
[[ $TERM == "xterm-kitty" ]] && alias ssh="kitty +kitten ssh"

# Sync dotfiles using GNU stow
alias dotsync='stow -d ~/git/dotfiles/ -t ~/ .'

# Git
alias ga='git add'
alias gpl='git pull'
alias gph='git push'
alias gr='git reset'
alias gcm='git commit'
alias gaa='git add .'
alias gt='git status'
alias gd='batdiff || git diff'

alias gpr='git pull --rebase'
alias gst='git status --short --no-renames | fzf --ansi --preview='\''echo {} | sed "s/.. //" | xargs git diff | delta'\'

alias grh='git reset --hard'
alias grs='git reset --soft'
alias grhh='git reset --hard HEAD'
alias grsh='git reset --soft HEAD'
