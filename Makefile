SCRIPT=./install.sh

all: main

main:
	$(SCRIPT)

install_paru:
	$(SCRIPT) install_paru

install_packages:
	$(SCRIPT) install_packages

install_spicetify:
	$(SCRIPT) install_spicetify

setup_nushell_caches:
	$(SCRIPT) setup_nushell_caches

setup_gitconfig:
	$(SCRIPT) setup_gitconfig

sync:
	$(SCRIPT) link_dotfiles

apply_wallpaper_colors:
	$(SCRIPT) apply_wallpaper_colors
