{
  description = "Entry point for my configs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
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
        modules = [
		./hosts/luffy
	 ];
	};
    };
  };
}

