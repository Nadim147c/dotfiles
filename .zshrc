# Download Zinit, if it's not there yet
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
	mkdir -p "$(dirname "$ZINIT_HOME")"
	git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
# Source/Load zinit
source "$ZINIT_HOME/zinit.zsh"

# Exports
export FZF_DEFAULT_OPTS='
--color=fg:#cdd6f4,header:#a6e3a1,info:#94e2d5,pointer:#f5e0dc
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#94e2d5,hl+:#a6e3a1
--info inline-right --layout reverse --border
'
command -v sccache &>/dev/null && export RUSTC_WRAPPER=sccache

export PATH="$PATH:$HOME/.local/bin:/usr/local/go/bin:$HOME/.cargo/bin:$HOME/.local/share/pnpm/:$HOME/.spicetify/"
export PNPM_HOME="$HOME/.local/share/pnpm/"
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

export EDITOR="nvim"
export VISUAL="nvim"

source "$HOME/git/zxutils/path"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light djui/alias-tips
zinit light Nadim147c/zsh-help
zinit light mattmc3/zsh-safe-rm
zinit light MichaelAquilina/zsh-autoswitch-virtualenv

# Add in snippets
zinit snippet OMZP::nvm
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::thefuck
zinit snippet OMZP::git-auto-fetch
zinit snippet OMZP::command-not-found

zstyle ':omz:plugins:nvm' silent-autoload yes

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# History
export HISTSIZE=5000
export HISTFILE="$HOME/.local/share/zsh_history"
export SAVEHIST=$HISTSIZE
export HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu no
# cd completion
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza --color=always $realpath'
# Kill process completion
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags '--preview-window=down:3:wrap'
# Systemd
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'

# Custom binding
bindkey "^p" history-search-backward
bindkey "^n" history-search-forward
bindkey "^[[H" beginning-of-line # Key Home
bindkey "^[[F" end-of-line       # Key End
bindkey '^[[3;5~' kill-word
bindkey '^H' backward-kill-word
bindkey "^K" forward-word
bindkey "^J" backward-word
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# alias
alias reload='clear && source ~/.zshrc'
alias config='nvim ~/.zshrc'
alias stdn='sudo shutdown now'
alias svim='sudo -Es nvim'

# cargo install eza
# LS alias
if command -v eza &>/dev/null; then
	alias ls='eza --color=always --icons'
	alias l='eza --color=always --icons -ial'
	alias la='eza --color=always --icons -ia'
	alias tree='eza --color=always --icons -ia --tree --git-ignore'
fi

# Bat and Bat extra
command -v bat &>/dev/null && alias cat=bat
command -v batman &>/dev/null && alias man=batman
command -v batdiff &>/dev/null && alias diff=batdiff

# GNU coreutils
alias s.="xdg-open ."
alias start="xdg-open"
alias cp='cp -i'
alias mv='mv -i'
alias xrm='xargs rm'
alias du='du -h'
alias mkdir='mkdir -p'

# Zellij
alias za='zellij a $(zellij ls -n | fzf | cut -d" " -f1)'
alias zr='zellij delete-session $(zellij ls | fzf | cut -d" " -f1)'
alias zda='zellij delete-all-sessions'
alias zn='zellij -s'

alias vim=nvim
alias n=pnpm
alias pm=pm2
alias yt=yt-dlp
alias ffmpeg='ffmpeg -hide_banner'

# Fix ssh weirdness with kitty
command -v kitty &>/dev/null && alias ssh="kitty +kitten ssh"

# Sync dotfiles using GNU stow
alias dotsync='stow -d ~/git/dotfiles/ -t ~/'

eval "$(starship init zsh)"
eval "$(thefuck --alias f)"
eval "$(zoxide init zsh --cmd cd)"
eval "$(fzf --zsh)"
