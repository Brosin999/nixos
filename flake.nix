{
  description = "Entry point for my configs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    #nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
   
    home-manager = {
	 url = "github:nix-community/home-manager/master";
	 # url = "github:nix-community/home-manager/release-25.05";

         # The `follows` keyword in inputs is used for inheritance.
         # Here, `inputs.nixpkgs` of home-manager is kept consistent with the `inputs.nixpkgs` of the current flake,
         # to avoid problems caused by different versions of nixpkgs dependencies.
         inputs.nixpkgs.follows = "nixpkgs";
	};
  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    nixosConfigurations = {
      karoo = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
	specialArgs = {
		self = self;
		nixpkgs = nixpkgs;
	};
        modules = [ 
		./hosts/karoo
	];
      };

      luffy = nixpkgs.lib.nixosSystem {	
	system = "x86_64-linux";
	specialArgs = {
		# quick hack to make external editor work
		pkgs-unstable = nixpkgs.legacyPackages."x86_64-linux";
	};
        modules = [
		./hosts/luffy
		home-manager.nixosModules.home-manager
	 ];
	};
    };
  };
}

