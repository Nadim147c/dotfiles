alias vim=nvim
alias n=pnpm
alias pm=pm2
alias yt=yt-dlp

alias ffmpeg='ffmpeg -hide_banner'
alias reload='clear && source ~/.zshrc'
alias config='nvim ~/.zshrc'
alias stdn='sudo shutdown now'
alias svim='sudo -Es nvim'
alias start="xdg-open"
alias s.="xdg-open ."

# LS alias (cargo install eza)
alias cls='command ls'
if command -v eza &>/dev/null; then
	alias ls='eza --color=always --icons'
	alias l='eza --color=always --icons -ial'
	alias la='eza --color=always --icons -ia'
	alias tree='eza --color=always --icons -ia --tree --git-ignore'
else
	echo "eza command is missing"
fi

# CD
alias rd='cd -' # Return to previous directory
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Bat and Bat extra
command -v bat &>/dev/null && alias cat=bat || echo "bat command is missing"
command -v batman &>/dev/null && alias man=batman || echo "batman command is missing"
command -v batdiff &>/dev/null && alias diff=batdiff || echo "batdiff command is missing"

# GNU coreutils
alias cp='cp -i'
alias mv='mv -i'
alias xrm='xargs rm'
alias du='du -h'
alias mkdir='mkdir -p'

# Fix ssh weirdness with kitty
command -v kitty &>/dev/null && alias ssh="kitty +kitten ssh"

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

alias grh='git reset --hard'
alias grs='git reset --soft'
alias grhh='git reset --hard HEAD'
alias grsh='git reset --soft HEAD'
