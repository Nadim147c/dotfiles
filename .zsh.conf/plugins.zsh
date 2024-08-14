function _zinit_wait_for() { echo -n 'zinit plugins '"$1"' | tail +2 |  sed '\''s/\x1b\[[0-9;]*[a-zA-Z]//g'\'' | grep -q '"$1"; }

zinit light-mode depth1 for \
    id-as"bin-gem" zdharma-continuum/zinit-annex-bin-gem-node \
    id-as"patch-dl" zdharma-continuum/zinit-annex-patch-dl

# The big 3
zinit lucid light-mode depth1 atload"zicompinit; zicdreplay" for \
    blockf zsh-users/zsh-completions \
    blockf zchee/zsh-completions

zinit lucid light-mode depth1 wait"$(_zinit_wait_for zsh-users/zsh-completions)" for \
    atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
    zsh-users/zsh-autosuggestions

zinit lucid light-mode wait"$(_zinit_wait_for fzf)" for Aloxaf/fzf-tab

local lazy_comp="lazycomplete"
[[ $commands[pnpm] ]] && lazy_comp+=" pnpm 'pnpm completion zsh'"
[[ $commands[warp-cli] ]] && lazy_comp+=" warp-cli 'warp-cli generate-completions zsh'"
zinit lucid light-mode wait for as"program" from"gh-r" atload"source <($lazy_comp)" rsteube/lazycomplete

# My forked plugins
zinit lucid light-mode depth1 wait for \
    Nadim147c/zsh-archlinux \
    Nadim147c/zsh-help

# All plugins
zinit lucid light-mode depth1 wait for \
    MichaelAquilina/zsh-autoswitch-virtualenv \
    Freed-Wu/zsh-command-not-found \
    djui/alias-tips \
    zshzoo/cd-ls

# Git plugins
zinit lucid light-mode depth1 wait for \
    id-as"git-extras" as"program" pick"$ZPFX/bin/git-*" src"etc/git-extras-completion.zsh" make"install PREFIX=$ZPFX" tj/git-extras \
    id-as"git-quick-stats" make"install _INSTDIR=$ZPFX" arzzen/git-quick-stats \
    id-as"git-recall" make"install PREFIX=$ZPFX" Fakerr/git-recall \
    id-as"git-open" paulirish/git-open

# Add snippets
zinit lucid wait for \
    OMZP::git-auto-fetch \
    OMZP::extract \
    OMZP::thefuck \
    OMZP::sudo

# Mise and it's apps
local QUIET="&>/dev/null"
local mise_atclone="cp -ru ./man* $ZPFX;\$(pwd)/mise activate zsh > init.zsh;\$(pwd)/mise completion zsh > _mise;\$(pwd)/mise install -y usage"
zinit lucid light-mode wait for as"program" from"gh-r" bpick"*.tar.gz" extract"!" mv"bin/mise -> mise" \
    atclone"$mise_atclone" atpull"%atclone" src"init.zsh" nocompile'!' \
    atload"mise use -g usage $QUIET" \
    jdx/mise

zinit lucid light-mode depth1 wait"$(_zinit_wait_for jdx/mise)" for \
    id-as"eza" atclone"mise use -g jq;mise install -y eza" atpull"%atclone" atload"mise use -g eza $QUIET" eza-community/eza \
    id-as"bat" atclone"mise install -y bat" atpull"%atclone" atload"mise use -g bat bat-extras $QUIET" cloneopts @sharkdp/bat

unset QUIET

# delta
zinit lucid light-mode wait for \
    id-as"delta" from"gh-r" as"command" mv"delta-* -> delta" pick"delta/delta" \
    dl"https://raw.githubusercontent.com/dandavison/delta/main/etc/completion/completion.zsh -> _delta;" \
    dandavison/delta

# fzf
zinit pack"bgn-binary+keys" for fzf

# zoxide
local zoxide_atclone="./zoxide init zsh --cmd cd > init.zsh"
zinit lucid light-mode wait for as"program" from"gh-r" atclone"$zoxide_atclone" atpull"%atclone" src"init.zsh" \
    id-as"zoxide" ajeetdsouza/zoxide

# FastFetch
local fastfetch_atclone="
echo 'fastfetch' > init.zsh
mv -vf fastfetch*/usr/share/man/man1/fastfetch.1 $ZPFX/man/man1
mv -vf fastfetch*/usr/share/fastfetch/presets .
"
zinit lucid light-mode for from"gh-r" as"program" bpick"fastfetch-linux-amd64.tar.gz" \
    mv"fastfetch*/usr/bin/fastfetch -> fastfetch" pick"fastfetch*/fastfetch" \
    atclone"$fastfetch_atclone" atpull"%atclone" src"init.zsh" \
    id-as"fastfetch" fastfetch-cli/fastfetch

# Starship prompt
local starship_atclone="./starship init zsh > init.zsh; ./starship completions zsh > _starship"
zinit lucid light-mode for from"gh-r" atclone"$starship_atclone" atpull"%atclone" src"init.zsh" \
    id-as"starship" starship/starship
