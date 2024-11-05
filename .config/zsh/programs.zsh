# the f**k file exclude rule
export THEFUCK_EXCLUDE_RULES=$'fix_file'
export CARAPACE_MATCH=CASE_INSENSITIVE

local PROGRAMS=(
    # Install fzf
    dl="$(printf 'https://raw.githubusercontent.com/junegunn/fzf/master/%s;' \
        shell/{'completion.zsh -> _fzf',key-bindings.zsh} \
        man/man1/fzf{,-tmux}.1)"
    lbin='!fzf'
    @junegunn/fzf

    atpull='%atclone' atclone=$'
    ./atuin gen-completions --shell zsh > _atuin
    ./atuin init --disable-up-arrow zsh > init.zsh
    echo "export ZSH_AUTOSUGGEST_STRATEGY=(atuin)" >> init.zsh'
    lbin='!atuin' extract='!' bpick='*.tar.gz' compile='init.zsh' src='init.zsh'
    @atuinsh/atuin

    atpull="%atclone" atclone='./carapace _carapace > init.zsh'
    lbin='!carapace' compile='init.zsh' src"init.zsh" atload="zicompinit;zicdreplay"
    carapace-sh/carapace-bin

    # Install mise package manager
    atpull="%atclone" atclone='
    $(pwd)/bin/mise activate zsh > init.zsh
    $(pwd)/bin/mise completion zsh > _mise
    $(pwd)/bin/mise install -y usage'
    lbin='!bin/mise' bpick='*.tar.gz' extract='!' compile='init.zsh' src='init.zsh'
    jdx/mise

    # Install vivid LS_COLORS generator
    atpull='%atclone' atclone=$'echo "export LS_COLORS=\'$(./vivid generate catppuccin-mocha)\'" > init.zsh'
    lbin='!vivid' bpick="*.tar.gz" extract='!' compile='init.zsh' src='init.zsh'
    @sharkdp/vivid

    # Install fd finder
    atload="alias files='fd --type f . --'"
    lbin='!**/fd' @sharkdp/fd

    # Install eza (ls with colors and icons)
    atload="
    alias e='eza --icons'
    alias ls='eza --icons'
    alias ll='eza --icons --long'
    alias l='eza --color=always --icons -ialh'
    alias la='eza --color=always --icons -ia'
    alias tree='eza --color=always --icons=always -ia --tree --git-ignore | less -r -F'"
    dl='https://github.com/eza-community/eza/blob/main/completions/zsh/_eza'
    lbin='!eza' eza-community/eza

    # Install bat (cat with wings)
    atload'alias cat=bat'
    lbin='!**/bat' @sharkdp/bat

    # Install bat-extras (uses power of bat)
    atload=$'alias man=batman; alias diff=\'batdiff --delta\''
    lbin='!bin/*' eth-p/bat-extras

    # Install delta diff parser
    lbin="!**/delta" dandavison/delta

    # Install grep but faster
    lbin="!**/rg" BurntSushi/ripgrep

    # Install The F**k
    atpull='%atclone' atclone=$'
    mise use -yj2 python@3.11 pipx
    pipx upgrade --install --python 3.11 --fetch-missing-python thefuck
    thefuck --alias > init.zsh
    thefuck --alias f >> init.zsh'
    from='gh' depth1 compile='init.zsh' src"init.zsh"
    wait="_zinit_check_plugin mise"
    nvbn/thefuck

    # Install GRC (Generic Colorizer)
    atload=$'export GRC_CONFIG="$ZPFX/etc/grc.conf"; export GRC_COLOUR_PATH="$ZPFX/share/grc/"'
    from='gh' atpull='%atclone' atclone='./install.sh $ZPFX $ZPFX'
    lbin"!(grc|grcat)" compile="grc.zsh" src'grc.zsh'
    Nadim147c/grc

    atload=$'
    export CHROMASHIFT_CONFIG="$HOME/git/ChromaShift/config.toml"
    export CHROMASHIFT_RULES="$HOME/git/ChromaShift/rules"
    alias docker="csudo docker"'
    atpull='%atclone' atclone="./bin/cshift alias zsh > init.zsh"
    lbin="!bin/cshift" compile='init.zsh' src='init.zsh'
    wait="_zinit_check_plugin grc"
    Nadim147c/ChromaShift

    # Install zellij
    lbin="!zellij" zellij-org/zellij

    # Install cd but you don't know where you're going
    atpull='%atclone' atclone="./zoxide init zsh --cmd cd > init.zsh"
    lbin='!zoxide' compile='init.zsh' src="init.zsh"
    ajeetdsouza/zoxide

    atload='[[ -z "$TMUX" && -z "$ZELLIJ" ]] && clear && fastfetch'
    lbin="!*/bin/*" extract="!"
    fastfetch-cli/fastfetch

    # Install starship the slowest shell prompt (probably)
    atpull='%atclone' atclone="./starship init zsh > init.zsh; ./starship completions zsh > _starship"
    lbin='!starship' compile='init.zsh' src"init.zsh" wait'!'
    starship/starship
)

zinit light-mode as'null' from'gh-r' nocompile'!' id-as lman wait for $PROGRAMS
