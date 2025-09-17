{ pkgs, config, ...}:
{
	imports = [
		./fonts.nix
		./system-packages.nix
		./nix.nix
		./hyprland.nix
	];
}
