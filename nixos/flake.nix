{
  description = "NixOS configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    system = "x86_64-linux";  # Corretto nome dell'architettura
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations.efesto = nixpkgs.lib.nixosSystem {
      system = system;  # Specifica il sistema
      specialArgs = { inherit inputs; };  # Passa gli inputs come argomenti speciali
      modules = [
        ./hosts/efesto/configuration.nix  # Configurazione host-specifica
        ./modules/nixos                   # Moduli personalizzati
        inputs.home-manager.nixosModules.default  # Integrazione di home-manager
      ];
    };
  };
}
