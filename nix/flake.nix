{
  description = "NixOS configuration flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plugin-harpoon = {
      url = "git+https://github.com/ThePrimeagen/harpoon?ref=harpoon2";
      flake = false;
    };

    zen-browser = "github:0xc000022070/zen-browser-flake";
  };

  outputs =
    { self
    , nixpkgs
    , nix-darwin
    , home-manager
    , zen-browser
    , ...
    } @ inputs:
    let
      linuxSystem = "x86_64-linux";
      linuxPkgs = nixpkgs.legacyPackages.${linuxSystem};
    in
    {
      nixosConfigurations.athena = nixpkgs.lib.nixosSystem {
        system = linuxSystem;
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/athena/configuration.nix
        ];
      };

      nixosConfigurations.hera = nixpkgs.lib.nixosSystem {
        system = linuxSystem;
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/hera/configuration.nix
        ];
      };

      nixosConfigurations.hephaestus = nixpkgs.lib.nixosSystem {
        system = linuxSystem;
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/hephaestus/configuration.nix
        ];
      };

      darwinConfigurations.idun = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/idun/configuration.nix
        ];
      };
    };
}
