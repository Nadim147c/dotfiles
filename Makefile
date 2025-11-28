all: switch

switch:
	nh os switch .

clean:
	nh clean all -k3

nixos:
	sudo nixos-rebuild switch --flake .
