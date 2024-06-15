{
	description = "Top level NixOS Flake";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

		nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

		home-manager.url = "github:nix-community/home-manager";
		home-manager.inputs.nixpkgs.follows = "nixpkgs";

	};

	outputs = { self, nixpkgs, home-manager, nixpkgs-unstable, ... }@inputs: let
		inherit (self) outputs;

	systems = [
		"x86_64-linux"
	];

	pkgs = import nixpkgs {
		system = "x86_64-linux";
		config = {
			allowUnfree = true;
			permittedInsecurePackages = [
				"electron-25.9.0"
			];
		};
	};

	forAllSystems = nixpkgs.lib.genAttrs systems;
	in  {

		overlays.additions = final: _prev: import ./pkgs final.pkgs;

		overlays.unstable = final: prev: {
			unstable = import nixpkgs-unstable {
				system = prev.system;
				config.allowUnfree = prev.config.allowUnfree;
			};
		};

		nixpkgs.overlays = [
			self.overlays.unstable
		];

		nixosConfigurations.olimpo = nixpkgs.lib.nixosSystem {
			specialArgs = {
				inherit inputs outputs;
				meta = { hostname = "olimpo"; };
			};
			system = "x86_64-linux";
			modules = [
				./machines/olimpo/hardware-configuration.nix
				./configuration.nix
					({ config, pkgs, ...}: {
					 nixpkgs.overlays = [
					 self.overlays.unstable
					 ];
					 })
			home-manager.nixosModules.home-manager
			{
				home-manager.useGlobalPkgs = true;
				home-manager.useUserPackages = true;
				home-manager.users.prometeo = import ./home/home.nix;
				home-manager.extraSpecialArgs = { inherit inputs; };
			}];
		};
		homeConfigurations.prometeo = home-manager.lib.homeManagerConfiguration {
			inherit pkgs;

			extraSpecialArgs = { inherit inputs; };

			modules = [
				./home.nix
			];
		};
	};
}
