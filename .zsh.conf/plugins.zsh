function _zinit_wait_for() { echo -n $'printf \'%s\\\\n\' $ZINIT_REGISTERED_PLUGINS | grep -q '"$1"; }

zinit light-mode depth1 for \
    id-as"bin-gem" zdharma-continuum/zinit-annex-bin-gem-node \
    id-as"patch-dl" zdharma-continuum/zinit-annex-patch-dl

# The big 3
zinit light-mode depth1 atload"zicompinit; zicdreplay" for \
    blockf zsh-users/zsh-completions \
    blockf zchee/zsh-completions

zinit light-mode depth1 wait"$(_zinit_wait_for zsh-users/zsh-completions)" for \
    atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
    zsh-users/zsh-autosuggestions

# Mise and it's apps
local mise_atclone=$'
cp -ru ./man* $ZPFX
$(pwd)/mise activate zsh > init.zsh
$(pwd)/mise completion zsh > _mise
$(pwd)/mise install -y usage'
zinit light-mode for as"program" from"gh-r" bpick"*.tar.gz" extract"!" mv"bin/mise -> mise" \
    atclone"$mise_atclone" atpull"%atclone" src"init.zsh" nocompile'!' \
    id-as"mise" jdx/mise

mise use -ygj8 \
    usage jq sccache \
    ripgrep fd eza \
    bat bat-extras delta &&
    clear

# fzf
zinit pack"bgn-binary+keys" for fzf
zinit light-mode wait"$(_zinit_wait_for fzf)" for Aloxaf/fzf-tab

local lazy_comp="lazycomplete"
[[ $commands[pnpm] ]] && lazy_comp+=" pnpm 'pnpm completion zsh'"
[[ $commands[bun] ]] && lazy_comp+=" bun 'bun completions --help'"
[[ $commands[warp-cli] ]] && lazy_comp+=" warp-cli 'warp-cli generate-completions zsh'"
zinit light-mode wait for as"program" from"gh-r" atload"source <($lazy_comp)" rsteube/lazycomplete

# Load better command_not_found_handler for Arch Linux
local archlinux_command_not_found=$'
[[ $commands[findpkg] ]] && command_not_found_handler() { findpkg "$1"; }'
zinit light-mode depth1 wait for \
    atload"$archlinux_command_not_found" Freed-Wu/zsh-command-not-found

# Load LS_COLORS
local vivid_atclone=$'
local LS_COLORS=$(./vivid generate molokai)
echo "export LS_COLORS=\'$LS_COLORS\'" > init.zsh'
zinit light-mode as"program" from"gh-r" bpick"*.tar.gz" for \
    extract"!" atclone"$vivid_atclone" atpull"%atclone" src"init.zsh" \
    id-as"LS_COLORS" @sharkdp/vivid

# All plugins
zinit light-mode depth1 wait for \
    MichaelAquilina/zsh-autoswitch-virtualenv \
    djui/alias-tips \
    zshzoo/cd-ls

# Load the smart word kill
local kill_word_binding=$'
bindkey \'^h\'       smart-backward-kill-word
bindkey \'\\e[3;5~\' smart-forward-kill-word'
zinit light-mode depth1 wait for atload"$kill_word_binding" seletskiy/zsh-smart-kill-word

# Git plugins
zinit light-mode depth1 wait for \
    id-as"git-extras" as"program" pick"$ZPFX/bin/git-*" src"etc/git-extras-completion.zsh" make"install PREFIX=$ZPFX" tj/git-extras \
    id-as"git-quick-stats" make"install _INSTDIR=$ZPFX" arzzen/git-quick-stats \
    id-as"git-recall" make"install PREFIX=$ZPFX" Fakerr/git-recall \
    id-as"git-open" paulirish/git-open

# Add snippets
zinit light-mode is-snippet wait for \
    OMZP::git-auto-fetch \
    OMZP::extract \
    OMZP::sudo \
    OMZP::man \
    OMZP::cp

# My forked plugins
export GENCOMPL_FPATH="$ZINIT[COMPLETIONS_DIR]"
export HELP_PAGER="$PAGER"
[[ $commands[powerpill] ]] && export PACMAN_WRAPPER=powerpill
zinit light-mode depth1 wait for \
    Nadim147c/zsh-completion-generator \
    Nadim147c/zsh-archlinux \
    Nadim147c/zsh-help

# The F**k
export THEFUCK_EXCLUDE_RULES=$'fix_file'
local thefuck_atclone=$'
mise use -ygj2 python pipx
pipx upgrade --install --python 3.11 --fetch-missing-python thefuck
thefuck --alias > init.zsh
thefuck --alias f >> init.zsh
thefuck --alias wtf >> init.zsh
thefuck --alias hell >> init.zsh
thefuck --alias bruh >> init.zsh
thefuck --alias damn >> init.zsh'
zinit light-mode depth1 wait for \
    atclone"$thefuck_atclone" atpull"%atclone" src"init.zsh" nocompile"!" \
    nvbn/thefuck

# zoxide
zinit light-mode wait for as"program" from"gh-r" \
    atclone"./zoxide init zsh --cmd cd > init.zsh" atpull"%atclone" src"init.zsh" \
    id-as"zoxide" ajeetdsouza/zoxide

local fastfetch_atclone=$'
echo \'fastfetch\' > init.zsh
mv -vf fastfetch*/usr/share/man/man1/fastfetch.1 $ZPFX/man/man1
mv -vf fastfetch*/usr/share/fastfetch/presets .'
zinit light-mode for from"gh-r" as"program" bpick"fastfetch-linux-amd64.tar.gz" \
    mv"fastfetch*/usr/bin/fastfetch -> fastfetch" pick"fastfetch*/fastfetch" \
    atclone"$fastfetch_atclone" atpull"%atclone" src"init.zsh" \
    id-as"fastfetch" fastfetch-cli/fastfetch

# Starship prompt
local starship_atclone="./starship init zsh > init.zsh; ./starship completions zsh > _starship"
zinit light-mode for from"gh-r" atclone"$starship_atclone" atpull"%atclone" src"init.zsh" \
    id-as"starship" starship/starship
