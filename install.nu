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
    neovim zellij
    base-devel sccache curl make wget
        # Git
    git git-extras git-delta
]

def title [msg: string] {
    print $"\n(ansi green) => (ansi reset) (ansi attr_bold)($msg)(ansi reset)\n"
}

def question [msg: string]: nothing -> bool {
    (input $"(ansi green)(ansi attr_bold)($msg) (ansi grey)\(Y/n\)(ansi reset) ") !~ "^[Yy]?$"
}

# Install paru
#
# Paru is AUR (Arch user repository) help. It helps us to download packages from AUR and build theme
# And install them using single command.
def install_paru [] {
    if (which paru | is-empty) {
        if (question "Install paru (AUR Helper)") {return}

        title "Installing paru (AUR Helper)"
        sudo pacman -S --needed base-devel
        git clone https://aur.archlinux.org/paru.git ~/.cache/paru/clone/paru
        cd ~/.cache/paru/clone/paru
        makepkg -si
    }
}

def install_packages [] {
    if (question "Update the system and install required packages?") {return}
    title "Updating system and installing packages"
    paru -Syu --needed ...$pkgs
}

def install_spicetify [] {
    if (question "Install Spicetify?") {return}
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
}

def install_waybar_lyrics [] {
    if (question "Install Waybar Lyrics?") {return}
    title "Installing waybar-lyric"
    let repo = "https://github.com/Nadim147c/waybar-lyric"
    let dir = ("~/git/waybar-lyric/" | path expand)
    let script = $dir | path join "scripts"

    git clone $repo $dir | complete
    cd $script
    paru -Bi .
}

def setup_default_shell [] {
    if "SHELL" in $env and ($env.SHELL | path basename) == "zsh" { return }
    if (question "Set default shell to zsh?") {return}
    title "Setting Default shell to zsh"

    sudo chsh --shell /bin/zsh $env.USER
}

def setup_nushell_caches [] {
    if (question "Install Nushell caches?") {return}
    title "Installing nushell caches"
    mkdir ~/.cache/nushell/

    carapace _carapace nushell       | save -f ~/.cache/nushell/starship.nu
    cshift alias nu                  | save -f ~/.cache/nushell/chromashift.nu
    starship init nu                 | save -f ~/.cache/nushell/starship.nu
    zoxide init nushell --cmd cd     | save -f ~/.cache/nushell/zoxide.nu
    atuin init nu --disable-up-arrow | save -f ~/.cache/nushell/atuin.nu
    mise activate nu                 | save -f ~/.cache/nushell/mise.nu
}

def setup_gitconfig [] {
    let gitconfig_public = "~/.gitconfig.public" | path expand
    let gitconfig_main = "~/.gitconfig" | path expand

    let config_status = (rg --multiline "^\\[include\\]\\s*path = \"?~/.gitconfig.public\"?" $gitconfig_main | complete)
    if ($config_status | get exit_code ) == 0 {return}

    if (question "Setup .gitconfig file?") {return}

    title "Setting up gitconfig"

    # Symlink .gitconfig.public if it doesn't exist
    if not ($gitconfig_public | path exists) {
        ln -s ~/.gitconfig.public $gitconfig_public
    }

    # Check if .gitconfig includes .gitconfig.public, if not, add it
    "[include]\n    path = ~/.gitconfig.public\n" | save -a $gitconfig_main
}

def link_dotfiles [] {
    if (question "Stow dotfiles?") {return}
    title "Stowing dotfiles"
    stow -t $env.HOME . -vv --no-folding
}

def apply_wallpaper_colors [] {
    if (question "Generate colors from Matugen?") {return}
    title "Generating colors from matugen"
    ~/.local/bin/swww.nu
}

def apply_spicetify [] {
    if (question "Apply Spicetify?") {return}
    title "Applying Spicetify settings"
    spicetify restore backup apply
}

# This Nushell script automates the setup and configuration of an Arch Linux system with various utilities and customizations.
# It consists of multiple functions, each handling a specific installation or configuration task. Before executing any function, the script prompts the user for confirmation to proceed.
#
# Features of the Script:
#
# 1. Package Management:
#    - install_paru: Installs paru (AUR helper) if not installed.
#    - install_packages: Updates the system and installs predefined packages.
#
# 2. Software Customization:
#    - install_spicetify: Installs and configures Spicetify for Spotify customization.
#    - install_waybar_lyrics: Clones and installs waybar-lyric for displaying lyrics in Waybar.
#
# 3. Shell and Environment Setup:
#    - setup_default_shell: Changes the default shell to zsh.
#    - setup_nushell_caches: Configures Nushell caches for various tools.
#    - setup_gitconfig: Configures gitconfig file.
#
# 4. Dotfiles and Aesthetic Configuration:
#    - link_dotfiles: Uses stow to manage and apply dotfiles.
#    - apply_wallpaper_colors: Generates colors from Matugen based on the wallpaper.
#    - apply_spicetify: Applies Spicetify themes and color schemes.
def main [] {
    install_paru
    install_packages
    install_spicetify
    install_waybar_lyrics

    setup_default_shell
    setup_nushell_caches
    setup_gitconfig
    link_dotfiles

    apply_wallpaper_colors
    apply_spicetify
}
