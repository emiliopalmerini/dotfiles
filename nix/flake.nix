{
  description = "NixOS configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf.url = "github:notashelf/nvf";

    plugin-harpoon = {
      url = "git+https://github.com/ThePrimeagen/harpoon?ref=harpoon2";
      flake = false;
    };

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages.${system}.default = 
        (nvf.lib.neovimConfiguration {
          pkgs = pkgs;
          modules = [ ./nvf.nix];
        }).neovim;

      nixosConfigurations.athena = nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/athena/configuration.nix
          inputs.home-manager.nixosModules.default
          ./modules/nixos
        ];
      };

      homeConfigurations.haephestus = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs;
        modules = [
          ./hosts/haephestus/home.nix
        ];
      };

      # Configurazione per nix-darwin
      darwinConfigurations.idun = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/idun/configuration.nix
          inputs.home-manager.darwinModules.default
        ];
      };
    };
}
