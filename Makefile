all: switch

switch:
	nh os switch .

boot:
	nh os boot .

clean:
	nh clean all -k3

nixos:
	sudo nixos-rebuild switch --flake . -L
