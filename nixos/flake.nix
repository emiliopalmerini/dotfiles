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
    ghostty = {
      url = "github:ghostty-org/ghostty";
    };
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nix-darwin, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {

      nixosConfigurations.haephestus = nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/haephestus/configuration.nix
          inputs.home-manager.nixosModules.default
          ./modules/nixosModules
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

      darwinConfigurations.idun = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/idun/configuration.nix
          inputs.home-manager.darwinModules.default
        ];
      };
    };
}
