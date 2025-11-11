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

    # ghostty = {
    #   url = "github:ghostty-org/ghostty";
    # };

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
      # , ghostty
    , ...
    } @ inputs:
    let
      lib = import ./lib/default.nix { inherit inputs nixpkgs; };

      # Define machine lists
      nixosMachines = [ "dell-xps-15" "thinkpad-home-server" "vm-aarch64" "wsl" "dell-precision" ];
      darwinMachines = [ "macbook-air-m1" ];
    in
    {
      nixosConfigurations = lib.mkNixosConfigurations nixosMachines;
      darwinConfigurations = lib.mkDarwinConfigurations darwinMachines;
    };
}
