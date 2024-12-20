{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

     home-manager = {
       url = "github:nix-community/home-manager";
       inputs.nixpkgs.follows = "nixpkgs";
     };
  };

  outputs = { self, nixpkgs, ... }@inputs: 
  let
  	system = "x84_64-linux";
	pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    nixosConfigurations.efesto = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/efesto/configuration.nix
	./modules/nixos
	inputs.home-manager.nixosModules.default
      ];
    };
  };
}
