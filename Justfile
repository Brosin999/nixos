default:
	@just --list

[group('nix')]
switch:
	sudo nixos-rebuild switch --flake .#

[group('nix')]
up:
	nix flake update --commit-lock-file
