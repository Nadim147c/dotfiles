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
export PATH="$PATH:$HOME/.local/bin:/usr/local/go/bin:$HOME/.local/share/pnpm/:$HOME/.spicetify/"

source "$HOME/git/zxutils/path"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light djui/alias-tips
zinit light ianthehenry/zsh-autoquoter
zinit light Freed-Wu/zsh-help
zinit light mattmc3/zsh-safe-rm

# Add in snippets zinit snippet OMZP::sudo
zinit snippet OMZP::nvm
zinit snippet OMZP::git
zinit snippet OMZP::thefuck
zinit snippet OMZP::git-auto-fetch
zinit snippet OMZP::colored-man-pages
zinit snippet OMZP::command-not-found

zstyle ':omz:plugins:nvm' lazy yes

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# History
export HISTSIZE=5000
export HISTFILE=~/.zsh_history
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
zstyle ':completion:*' menu no zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza --color=always $realpath'

# Custom binding
bindkey "^p" history-search-backward
bindkey "^n" history-search-forward
bindkey "^[[H" beginning-of-line # Key Home
bindkey "^[[F" end-of-line       # Key End
bindkey '^[[3;5~' kill-word
bindkey '^H' backward-kill-word
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# alias
alias reload='clear && source ~/.zshrc'
alias config='nvim ~/.zshrc'
alias stdn='sudo shutdown now'
alias svim='sudo -Es nvim'

#cargo install eza
# LS alias
alias ls='eza --color=always --icons'
alias l='eza --color=always --icons -ial'
alias la='eza --color=always --icons -ia'
alias tree='eza --color=always --icons -ia --tree --git-ignore'

# GNU coreutils
alias cp='cp -i'
alias mv='mv -i'
alias du='du -h'

# Zellij
alias za='zellij a $(zellij ls -n | fzf | cut -d" " -f1)'
alias zr='zellij delete-session $(zellij ls | fzf | cut -d" " -f1)'
alias zda='zellij delete-all-sessions'
zn() {
	if [ -n "$1" ]; then
		zellij -s "$1"
	else
		echo 'Please pass session name as an argument'
	fi
}

alias vim=nvim
alias n=pnpm
alias pm=pm2
alias yt=yt-dlp

# Fix ssh weirdness with kitty
command -v kitty &>/dev/null && alias ssh="kitty +kitten ssh"
alias stow='stow -d ~/git/dotfiles/ -t ~/'

# Start user apps
zinit ice as"command" from"gh-r" \
	atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
	atpull"%atclone" src"init.zsh"
zinit light starship/starship

eval "$(thefuck --alias f)"
eval "$(zoxide init zsh --cmd cd)"
eval "$(fzf --zsh)"
