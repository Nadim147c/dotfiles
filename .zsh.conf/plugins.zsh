autoload -U url-quote-magic
zle -N self-insert url-quote-magic
unsetopt nomatch

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light djui/alias-tips
zinit light Nadim147c/zsh-help
zinit light mattmc3/zsh-safe-rm
zinit light MichaelAquilina/zsh-autoswitch-virtualenv
zinit light zshzoo/cd-ls

# Add in snippets
zinit snippet OMZP::sudo
zinit snippet OMZP::thefuck
zinit snippet OMZP::git-auto-fetch
zinit snippet OMZP::command-not-found
