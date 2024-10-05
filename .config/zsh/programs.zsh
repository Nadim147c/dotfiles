# the f**k file exclude rule
export THEFUCK_EXCLUDE_RULES=$'fix_file'

local PROGRAMS=(
    # Install fzf
    wait'!' pack fzf

    # Install mise package manager
    atpull"%atclone" atclone=$'
    $(pwd)/bin/mise activate zsh > init.zsh
    $(pwd)/bin/mise completion zsh > _mise
    $(pwd)/bin/mise install -y usage'
    bpick"*.tar.gz" src"init.zsh" extract'!' sbin"bin/mise -> mise"
    jdx/mise

    # Install vivid LS_COLORS generator
    atload'export LS_COLORS=$(vivid generate catppuccin-mocha)'
    bpick"*.tar.gz" as sbin'vivid'
    @sharkdp/vivid

    # Install fd finder
    atload"alias files='fd --type f . --'"
    sbin"**/fd" @sharkdp/fd

    # Install eza (ls with colors and icons)
    atload"
    alias e='eza --icons'
    alias ls='eza --icons'
    alias ll='eza --icons --long'
    alias l='eza --color=always --icons -ialh'
    alias la='eza --color=always --icons -ia'
    alias tree='eza --color=always --icons=always -ia --tree --git-ignore | less -r -F'"
    sbin'eza' eza-community/eza

    # Install bat (cat with wings)
    atload'alias cat=bat'
    sbin"**/bat" @sharkdp/bat

    # Install bat-extras (uses power of bat)
    atload$'alias man=batman; alias diff=\'batdiff --delta\''
    sbin"bin/*" eth-p/bat-extras

    # Install delta diff parser
    sbin"**/delta" dandavison/delta

    # Install grep but faster
    sbin"**/rg" BurntSushi/ripgrep

    # Install sed but it doesn't make you sad
    sbin'sd' chmln/sd

    # Install The F**k
    atclone=$'
    mise use -yj2 python@3.11 pipx
    pipx upgrade --install --python 3.11 --fetch-missing-python thefuck
    thefuck --alias > init.zsh
    thefuck --alias f >> init.zsh'
    src"init.zsh" nocompile"!"
    wait"_zinit_check_plugin mise"
    nvbn/thefuck

    # Install GRC (Generic Colorizer)
    atload$'
    export GRC_CONFIG="$ZPFX/etc/grc.conf"
    export GRC_COLOUR_PATH="$ZPFX/share/grc/"'
    from'gh' atclone'./install.sh $ZPFX $ZPFX' nocompile sbin"(grc|grcat)" src'grc.zsh' pick'$ZPFX/bin/grc*'
    Nadim147c/grc

    wait"_zinit_check_plugin grc"
    atload$'alias docker="csudo docker"'
    sbin"bin/colorize" src'scripts/alias.zsh'
    Nadim147c/colorize

    # Install zellij
    sbin"zellij" zellij-org/zellij

    # Install cd but you don't know where you're going
    atclone"./zoxide init zsh --cmd cd > init.zsh"
    src"init.zsh" sbin'zoxide'
    ajeetdsouza/zoxide

    # Install starship the slowest shell prompt (probably)
    atclone="./starship init zsh > init.zsh; ./starship completions zsh > _starship"
    src"init.zsh" wait'!'
    sbin'starship' starship/starship
)

zinit light-mode as'program' from'gh-r' id-as lman atpull"%atclone" wait for $PROGRAMS
