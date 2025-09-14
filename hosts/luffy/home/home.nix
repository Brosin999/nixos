{ config, pkgs, pkgs-unstable, ... }:
{
	# home manager info	
	home.username = "luffy";
	home.stateVersion = "25.05";

	imports = [
		./common
	];
}
