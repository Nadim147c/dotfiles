#!/bin/nu

let pkgs = [
    # System
    base-devel

    # Desktop env
        # Envs
    flatpak flatseal
        # Hyprland
    hyprland hypridle hyprlock hyprcursor hyprshot hyprsunset hyprpaper
    waybar swaync swww aur/waypaper waybar-lyric-git
        # Color
    matugen-bin python-pywal16 python-pywalfox
        # Clipboard
    wl-clipboard cliphist

    # Desktop Apps
        # Spotify
    spicetify-cli
        # Discord
    goofcord
        # Other
    nautilus loupe dolphin gnome-calendar

    # Shell
    zsh nushell carapace-bin starship zoxide mise
    eza atuin chromashift-git

    # CLI
    ripgrep fd sd fzf skim bat bat-extras fastfetch

    # Dev tools
        # Lang
    rustup go nodejs python3
        # Tool
    neovim zellij base-devel sccache curl make wget
        # Git
    git git-extras git-delta
]

let flatpak_pkg = [
    com.spotify.Client # Spotify
]

def title [msg: string] {
    print $"\n(ansi green) => (ansi reset) (ansi attr_bold)($msg)(ansi reset)\n"
}

def question [msg: string]: nothing -> bool {
    (input --numchar 1 $"(ansi green)(ansi attr_bold)($msg) (ansi grey)\(Y/n\)(ansi reset) ") !~ "^[Yy]?$"
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
    flatpak install --or-update flathub ...$flatpak_pkg
}

def install_spicetify [] {
    if (question "Install Spicetify?") {return}

    title "Installing spicetify"
    sudo chmod a+wr /var/lib/flatpak/app/com.spotify.Client/x86_64/stable/active/files/extra/share/spotify
    sudo chmod a+wr -R /var/lib/flatpak/app/com.spotify.Client/x86_64/stable/active/files/extra/share/spotify/Apps

    let theme_url = "https://github.com/spicetify/spicetify-themes/raw/refs/heads/master/Sleek/user.css"
    let theme_path = ("~/.config/spicetify/Themes/Sleek/user.css" | path expand)

    wget $theme_url -O "/tmp/spicetify.sleek.css"
    install --verbose -Dm644 "/tmp/spicetify.sleek.css" $theme_path

    spicetify config prefs_path ("~/.var/app/com.spotify.Client/config/spotify/prefs" | path expand)
    spicetify config spotify_path /var/lib/flatpak/app/com.spotify.Client/x86_64/stable/active/files/extra/share/spotify/
    spicetify config current_theme Sleek
    spicetify config color_scheme Matugen
    spicetify config custom_apps lyrics-plus


    if not (question "Install spicetify marketplace") {
        title "Installing spicetify market"
        curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-marketplace/main/resources/install.sh | sh
    }
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

    let cache_dir = ($nu.data-dir | path join "vendor/autoload")
    mkdir $cache_dir
    carapace _carapace nushell            | save -f $"($cache_dir)/carapace.nu"
    # cshift alias nu                       | save -f $"($cache_dir)/chromashift.nu"
    starship init nu                      | save -f $"($cache_dir)/starship.nu"
    zoxide init nushell --cmd cd          | save -f $"($cache_dir)/zoxide.nu"
    atuin init nu --disable-up-arrow      | save -f $"($cache_dir)/atuin.nu"
    atuin gen-completions --shell nushell | save -f -a $"($cache_dir)/atuin.nu"
    mise activate nu                      | save -f $"($cache_dir)/mise.nu"
}

def setup_gitconfig [] {
    let gitconfig_public = "~/.config/git/config.public" | path expand --no-symlink

    let included = ^git config --global --get-all include.path | lines

    if $gitconfig_public in $included {return}

    if (question "Setup .gitconfig file?") {return}

    title "Setting up gitconfig"

    ^git config --global --add include.path $gitconfig_public
}

def setup_waypaper [] {
    if (question "Setup waypaper config?") { return }

    title "Setting up waypaper"

    let config = $"
[Settings]
language = en
folder = ~/Pictures/Wallpapers
post_command = (echo "~/.local/bin/wallpaper.nu" | path expand --no-symlink) --no-set-wallpaper $wallpaper
backend = hyprpaper
show_path_in_tooltip = False
"
    mkdir --verbose ~/.config/waypaper
    echo $config | str trim | save --force ~/.config/waypaper/config.ini
}

def link_dotfiles [] {
    if (question "Stow dotfiles?") {return}
    title "Stowing dotfiles"
    stow -t $env.HOME . -vv --no-folding
}

def apply_wallpaper_colors [] {
    if (question "Generate colors from Matugen?") {return}
    title "Generating colors from matugen"
    ~/.local/bin/wallpaper.nu
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

    setup_default_shell
    setup_nushell_caches
    setup_gitconfig
    setup_waypaper
    link_dotfiles

    apply_wallpaper_colors
    apply_spicetify
}
