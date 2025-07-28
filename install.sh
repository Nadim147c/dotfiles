#!/usr/bin/env bash

set -euo pipefail

pkgs=(
    # System
    base-devel git archlinux-xdg-menu findpkg
    zip unzip

    # Desktop env
    # Hyprland
    hyprland hypridle hyprlock hyprcursor hyprshot hyprsunset
    dunst wlogout waybar-lyric-git hyprpolkitagent wofi
    adw-gtk-theme breeze nwg-look qt6ct-kde bibata-cursor-theme
    cava
    # Color
    python-pywalfox
    # Clipboard
    wl-clipboard cliphist
    kdeconnect blueman

    # Desktop Apps
    zen-browser-bin
    equibop-bin
    mpv ffmpeg

    nautilus loupe dolphin gnome-calendar
    thunar tumbler ffmpegthumbnailer libgsf tumbler-extra-thumbnailers thunar-archive-plugin
    thunar-media-tags-plugin thunar-shares-plugin thunar-vcs-plugin

    # Fonts
    noto-fonts noto-fonts-extra noto-fonts-emoji
    ttf-jetbrains-mono-nerd ttf-klee-one

    # Shell
    zsh fish nushell carapace-bin starship mise
    eza atuin chromashift-git zoxide

    # CLI
    ripgrep fd sd fzf skim bat bat-extras fastfetch tree

    # Dev tools
    # Lang
    rust go nodejs python3 dart-sass
    # Tool
    neovim zellij base-devel sccache curl make wget
    # Git
    git git-extras git-delta
)

title() {
    echo -e "\n\033[1;32m =>\033[0m \033[1m$1\033[0m\n"
}

question() {
    local prompt="$1"
    read -r -p "$(echo -e "\033[1;32m${prompt} \033[90m(Y/n)\033[0m ")" response
    [[ ! "$response" =~ ^[Yy]?$ ]]
}

install_paru() {
    if ! command -v paru &>/dev/null; then
        if question "Install paru (AUR Helper)"; then return; fi

        title "Installing paru (AUR Helper)"
        sudo pacman -S --needed base-devel
        if [[ ! -d ~/.cache/paru/clone/paru ]]; then
            git clone https://aur.archlinux.org/paru.git ~/.cache/paru/clone/paru
        fi
        cd ~/.cache/paru/clone/paru
        makepkg -si
    fi
}

install_packages() {
    if question "Update the system and install required packages?"; then return; fi
    title "Updating system and installing packages"
    paru -Syu --needed "${pkgs[@]}"
}

setup_nushell_caches() {
    if question "Install Nushell caches?"; then return; fi
    title "Installing nushell caches"

    mkdir -p ~/.cache/nushell/
    local cache_dir
    cache_dir="${XDG_DATA_HOME:-$HOME/.local/share}/nushell/vendor/autoload"
    mkdir -p "$cache_dir"

    zoxide init nushell --cmd cd >"$cache_dir/zoxide.nu"
    starship init nu >"$cache_dir/starship.nu"
    atuin init nu --disable-up-arrow >"$cache_dir/atuin.nu"
    atuin gen-completions --shell nushell >>"$cache_dir/atuin.nu"
    mise activate nu >"$cache_dir/mise.nu"
}

setup_gitconfig() {
    local gitconfig_public="$HOME/.config/git/config.public"

    if git config --global --get-all include.path | grep -qx "$gitconfig_public"; then return; fi
    if question "Setup .gitconfig file?"; then return; fi

    title "Setting up gitconfig"
    git config --global --add include.path "$gitconfig_public"
}

link_dotfiles() {
    if question "Stow dotfiles?"; then return; fi

    title "Stowing dotfiles"
    stow -t "$HOME" . -vv --no-folding
    touch "$HOME/.config/hypr/hyprpaper.conf"
}

apply_wallpaper_colors() {
    if question "Generate colors from rong?"; then return; fi

    title "Generating colors from matugen"
    ~/.local/bin/wallpaper.nu
}

install_spicetify() {
    if question "Install Spicetify?"; then return; fi

    title "Installing spicetify"
    local theme_url="https://github.com/spicetify/spicetify-themes/raw/refs/heads/master/Sleek/user.css"
    local theme_path="$HOME/.config/spicetify/Themes/Sleek/user.css"

    mkdir -p "$(dirname "$theme_path")"
    wget "$theme_url" -O "/tmp/spicetify.sleek.css"
    install -Dm644 "/tmp/spicetify.sleek.css" "$theme_path"

    spicetify config current_theme Sleek
    spicetify config color_scheme rong
    spicetify config custom_apps lyrics-plus

    if ! question "Install spicetify marketplace"; then
        title "Installing spicetify market"
        curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-marketplace/main/resources/install.sh | sh
    fi

    spicetify backend apply
}

main() {
    install_paru
    install_packages
    install_spicetify

    setup_nushell_caches
    setup_gitconfig
    link_dotfiles

    apply_wallpaper_colors
}

if [[ $# -eq 0 ]]; then
    main
else
    for fn in "$@"; do
        if declare -f "$fn" >/dev/null; then
            "$fn"
        else
            echo "Function '$fn' not found"
            exit 1
        fi
    done
fi
