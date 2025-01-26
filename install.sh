#!/bin/bash

PKGS=(
    # System
    zsh pacman-contrib
    hyprland hypridle hyprlock hyprcursor hyprshot
    waybar swaync swww
    matugen-bin python-pywal16 python-pywalfox
    bibata-cursor-theme
    nautilus loupe dolphin

    # Desktop Apps
    vesktop spotify spicetify-cli

    # Shell
    zsh nushell carapace-bin starship zoxide mise
    eza atuin chromashift-git waytune-git

    # CLI
    ripgrep fd sd fzf
    bat bat-extras fastfetch

    # Dev tools
    base-devel neovim zellij sccache
    git git-extras git-delta curl make wget
)

_print() {
    printf '\n\033[1;32m =>\033[0m \033[1m%s\033[0m\n\n' "$@"
}

if ! command -v paru; then
    _print "Installing paru (AUR Helper)"
    sudo pacman -S --needed base-devel
    git clone https://aur.archlinux.org/paru.git "$HOME/.cache/paru/clone/paru"
    cd "$HOME/.cache/paru/clone/paru" || exit
    makepkg -si
fi

_print "Updating system and installing packages"
paru -Syu --needed "${PKGS[@]}"

_print "Stowing the dotfiles"

_print "Setting Default shell to zsh"
sudo chsh --shell /bin/zsh "$USER"

_print "Installing nushell caches"
mkdir -p ~/.cache/nushell/
carapace _carapace nushell >~/.cache/nushell/starship.nu
starship init nu >~/.cache/nushell/starship.nu
zoxide init nushell --cmd cd >~/.cache/nushell/zoxide.nu
atuin init nu --disable-up-arrow --disable-ctrl-r >~/.cache/nushell/atuin.nu
mise activate nu >~/.cache/nushell/atuin.nu

_print "Stowing dotfiles"
stow -t "$HOME/" . -vv

_print "Generating colors from matugen"
sh ./.config/hypr/scripts/swww.sh

_print "Installing spicetify"
sudo chmod a+wr /opt/spotify
sudo chmod a+wr /opt/spotify/Apps -R

[[ ! -f "$HOME/.config/spicetify/Themes/Sleek/user.css" ]] &&
    curl -L -o "$HOME/.config/spicetify/Themes/Sleek/user.css" \
        "https://raw.githubusercontent.com/spicetify/spicetify-themes/refs/heads/master/Sleek/user.css"

spicetify config current_theme Sleek
spicetify config color_scheme Matugen

spicetify apply -n
