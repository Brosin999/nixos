{ config, pkgs, ... }:
{
	# home manager info	
	home.username = luffy;
	home.stateVersion = 25.05;

	imports = [
		./common/toolbox.nix
	];

}
