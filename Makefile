all: switch

switch:
	nh os switch .

nixos:
	sudo nixos-rebuild switch --flake .
