{
  description = "NixOS configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plugin-harpoon = {
      url = "git+https://github.com/ThePrimeagen/harpoon?ref=harpoon2";
      flake = false;
    };

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {

      nixosConfigurations.haephestus = nixpkgs.lib.nixosSystem {
        system = system;  # Specifica il sistema
        specialArgs = { inherit inputs; };  # Passa gli inputs come argomenti speciali
        modules = [
          ./hosts/haephestus/configuration.nix         # Configurazione host-specifica
          inputs.home-manager.nixosModules.default # Default home-manager modules
          ./modules/nixosModules                   # Moduli personalizzati
        ];
      };

      nixosConfigurations.poseidon = nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/poseidon/configuration.nix
          inputs.home-manager.nixosModules.default
          ./modules/nixosModules
        ];
      };
    };
}
