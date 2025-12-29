{
  description = "NixOS configuration flake";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";

    plugin-harpoon = {
      url = "git+https://github.com/ThePrimeagen/harpoon?ref=harpoon2";
      flake = false;
    };

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
      lib = import ./lib/default.nix { inherit inputs nixpkgs; };

      # Define machine lists
      nixosMachines = [ "dell-xps-15" "thinkpad-home-server" "dell-precision" ];
      vmMachines = [ "vm-aarch64" ];
      darwinMachines = [ "macbook-air-m1" ];
    in
    {
      nixosConfigurations = lib.mkNixosConfigurations nixosMachines // lib.mkVmConfigurations vmMachines;
      darwinConfigurations = lib.mkDarwinConfigurations darwinMachines;
    };
}
