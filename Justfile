default:
	@just --list

[group('nix')]
switch:
	sudo nixos-rebuild switch --flake .#

[group('nix')]
up:
	nix flake update --commit-lock-file

[group('nix')]
fmt:
	nix-shell -p nixfmt-rfc-style deadnix statix typos; nixfmt; deadnix; statix -c; typos; exit;

[group('nix')]
gc:
	nix store gc




