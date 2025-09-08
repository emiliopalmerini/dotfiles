{ inputs, nixpkgs, ... }:
let
  linuxSystem = "x86_64-linux";
  darwinSystem = "aarch64-darwin";
  userLib = import ./users.nix;
  commonLib = import ./common.nix;
in
rec {
  # Expose user configurations
  users = userLib.users;
  getUserConfig = userLib.getUserConfig;
  
  # Expose common utilities  
  inherit (commonLib) mkEnvironment;

  # Helper function to create NixOS configurations
  mkNixosSystem = hostname: nixpkgs.lib.nixosSystem {
    system = linuxSystem;
    specialArgs = { 
      inherit inputs; 
      userConfig = getUserConfig hostname;
      commonEnv = mkEnvironment { isDarwin = false; };
    };
    modules = [
      ../hosts/${hostname}/configuration.nix
    ];
  };

  # Helper function to create Darwin configurations  
  mkDarwinSystem = hostname: inputs.nix-darwin.lib.darwinSystem {
    specialArgs = { 
      inherit inputs; 
      userConfig = getUserConfig hostname;
      commonEnv = mkEnvironment { isDarwin = true; };
    };
    modules = [
      ../hosts/${hostname}/configuration.nix
    ];
  };

  # Generate nixosConfigurations from host list
  mkNixosConfigurations = hostNames: 
    builtins.listToAttrs (
      map (host: { 
        name = host; 
        value = mkNixosSystem host; 
      }) hostNames
    );

  # Generate darwinConfigurations from host list
  mkDarwinConfigurations = hostNames:
    builtins.listToAttrs (
      map (host: { 
        name = host; 
        value = mkDarwinSystem host; 
      }) hostNames
    );
}