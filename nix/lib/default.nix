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

  # Helper function to create NixOS configurations (physical machines - x86_64)
  mkNixosSystem = machineName: nixpkgs.lib.nixosSystem {
    system = linuxSystem;
    specialArgs = {
      inherit inputs;
      userConfig = getUserConfig machineName;
      commonEnv = mkEnvironment { isDarwin = false; };
    };
    modules = [
      ../machines/${machineName}/configuration.nix
    ];
  };

  # Helper function to create VM configurations (aarch64-linux for ARM Macs)
  mkVmSystem = machineName: nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    specialArgs = {
      inherit inputs;
      userConfig = getUserConfig machineName;
      commonEnv = mkEnvironment { isDarwin = false; };
    };
    modules = [
      ../machines/${machineName}/configuration.nix
    ];
  };

  # Helper function to create Darwin configurations
  mkDarwinSystem = machineName: inputs.nix-darwin.lib.darwinSystem {
    specialArgs = {
      inherit inputs;
      userConfig = getUserConfig machineName;
      commonEnv = mkEnvironment { isDarwin = true; };
    };
    modules = [
      ../machines/${machineName}/configuration.nix
    ];
  };

  # Generate nixosConfigurations from machine list
  mkNixosConfigurations = machineNames:
    builtins.listToAttrs (
      map (machine: {
        name = machine;
        value = mkNixosSystem machine;
      }) machineNames
    );

  # Generate VM configurations from machine list
  mkVmConfigurations = machineNames:
    builtins.listToAttrs (
      map (machine: {
        name = machine;
        value = mkVmSystem machine;
      }) machineNames
    );

  # Generate darwinConfigurations from machine list
  mkDarwinConfigurations = machineNames:
    builtins.listToAttrs (
      map (machine: {
        name = machine;
        value = mkDarwinSystem machine;
      }) machineNames
    );
}