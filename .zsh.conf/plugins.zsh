function _zinit_wait_for() { echo -n 'zinit plugins '"$1"' | tail +2 |  sed '\''s/\x1b\[[0-9;]*[a-zA-Z]//g'\'' | grep -q '"$1"; }

zinit lucid light-mode depth1 wait for zdharma-continuum/zinit-annex-bin-gem-node

# The big 3
zinit lucid light-mode depth1 atload"zicompinit; zicdreplay" for \
    blockf zsh-users/zsh-completions \
    blockf zchee/zsh-completions

zinit lucid light-mode depth1 wait"$(_zinit_wait_for zsh-users/zsh-completions)" for \
    atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
    atload"!_zsh_autosuggest_start" zsh-users/zsh-autosuggestions

local lazy_comp="lazycomplete"
[[ $commands[pnpm] ]] && lazy_comp+=" pnpm 'pnpm completion zsh'"
[[ $commands[warp-cli] ]] && lazy_comp+=" warp-cli 'warp-cli generate-completions zsh'"
zinit lucid light-mode wait for as"command" from"gh-r" atload"source <($lazy_comp)" rsteube/lazycomplete

# My forked plugins
zinit lucid light-mode depth1 wait for \
    Nadim147c/zsh-archlinux \
    Nadim147c/zsh-help

# All plugins
zinit lucid light-mode depth1 wait for \
    MichaelAquilina/zsh-autoswitch-virtualenv \
    Freed-Wu/zsh-command-not-found \
    djui/alias-tips \
    Aloxaf/fzf-tab \
    zshzoo/cd-ls

# Git plugins
zinit lucid light-mode depth1 wait for \
    as"program" pick"$ZPFX/bin/git-*" src"etc/git-extras-completion.zsh" make"install PREFIX=$ZPFX" tj/git-extras \
    make"install _INSTDIR=$ZPFX" arzzen/git-quick-stats \
    make"install PREFIX=$ZPFX" Fakerr/git-recall \
    paulirish/git-open

# Add snippets
zinit lucid light-mode is-snippet wait for \
    OMZP::sudo \
    OMZP::thefuck \
    OMZP::git-auto-fetch

# Mise and it's apps
local QUIET="&>/dev/null"
local mise_atclone="cp -ru ./man* $ZPFX;\$(pwd)/mise activate zsh > init.zsh;\$(pwd)/mise completion zsh > _mise;\$(pwd)/mise install usage"
zinit lucid light-mode wait for as"program" from"gh-r" bpick"*.tar.gz" extract"!" mv"bin/mise -> mise" \
    atclone"$mise_atclone" atpull"%atclone" src"init.zsh" nocompile'!' \
    atload"mise use -g usage $QUIET" \
    jdx/mise

zinit as"null" lucid light-mode depth1 wait"$(_zinit_wait_for jdx/mise)" for \
    atclone"mise install eza" atpull"%atclone" atload"mise use -g eza $QUIET" eza-community/eza

unset QUIET

# fzf
zinit pack"bgn+keys" wait"$(_zinit_wait_for zdharma-continuum/zinit-annex-bin-gem-node)" for fzf

# zoxide
local zoxide_atclone="./zoxide init zsh --cmd cd > init.zsh"
zinit lucid light-mode wait for as"command" from"gh-r" atclone"$zoxide_atclone" atpull"%atclone" src"init.zsh" \
    ajeetdsouza/zoxide

# Starship prompt
local starship_atclone="./starship init zsh > init.zsh; ./starship completions zsh > _starship"
zinit ice as"command" from"gh-r" atclone"$starship_atclone" atpull"%atclone" src"init.zsh"
zinit light starship/starship
