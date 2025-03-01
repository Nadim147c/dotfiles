#!/bin/nu

let pkgs = [
    # System
    base-devel

    # Desktop env
        # Hyprland
    hyprland hypridle hyprlock hyprcursor hyprshot hyprsunset
    waybar swaync swww
        # Color
    matugen-bin python-pywal16 python-pywalfox

    # Desktop Apps
        # Spotify
    spotify spicetify-cli
        # Discord
    goofcord vesktop discord
        # Other
    nautilus loupe dolphin gnome-calendar

    # Shell
    zsh nushell carapace-bin starship zoxide mise
    eza atuin chromashift-git

    # CLI
    ripgrep fd sd fzf
    bat bat-extras fastfetch

    # Dev tools
        # Lang
    rustup go nodejs python3
        # Tool
    neovim zelli
    base-devel sccache curl make wget
        # Git
    git git-extras git-delta
]

def title [msg: string] {
    print $"\n(ansi green) => (ansi reset) (ansi attr_bold)($msg)(ansi reset)\n"
}

def install_paru [] {
    if (which paru | is-empty) {
        title "Installing paru (AUR Helper)"

        sudo pacman -S --needed base-devel
        git clone https://aur.archlinux.org/paru.git ~/.cache/paru/clone/paru
        cd ~/.cache/paru/clone/paru
        makepkg -si
    }
}

def install_packages [] {
    title "Updating system and installing packages"
    paru -Syu --needed ...$pkgs
}

def set_default_shell [] {
    title "Setting Default shell to zsh"
    sudo chsh --shell /bin/zsh $env.USER
}

def setup_nushell_caches [] {
    title "Installing nushell caches"
    mkdir ~/.cache/nushell/

    carapace _carapace nushell       | save -f ~/.cache/nushell/starship.nu
    cshift alias nu                  | save -f ~/.cache/nushell/chromashift.nu
    starship init nu                 | save -f ~/.cache/nushell/starship.nu
    zoxide init nushell --cmd cd     | save -f ~/.cache/nushell/zoxide.nu
    atuin init nu --disable-up-arrow | save -f ~/.cache/nushell/atuin.nu
    mise activate nu                 | save -f ~/.cache/nushell/mise.nu
}

def stow_dotfiles [] {
    title "Stowing dotfiles"
    stow -t $env.HOME/ . -vv
}

def generate_colors [] {
    title "Generating colors from matugen"
    ~/.local/bin/swww.nu
}

def install_spicetify [] {
    title "Installing spicetify"
    sudo chmod a+wr /opt/spotify
    sudo chmod a+wr /opt/spotify/Apps -R

    let theme_url = "https://github.com/spicetify/spicetify-themes/raw/refs/heads/master/Sleek/user.css"
    let theme_path = ("~/.config/spicetify/Themes/Sleek/user.css" | path expand)

    if not ($theme_path | path exists) {
        http get $theme_url | save -f $theme_path
    }

    spicetify config current_theme Sleek
    spicetify config color_scheme Matugen
    spicetify apply -n
}

def main [] {
    install_paru
    install_packages
    set_default_shell
    setup_nushell_caches
    stow_dotfiles
    generate_colors
    install_spicetify
}
