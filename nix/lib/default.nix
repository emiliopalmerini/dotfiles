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

  # Generate nixosConfigurations from machine list
  mkNixosConfigurations = machineNames:
    builtins.listToAttrs (
      map (machine: {
        name = machine;
        value = nixpkgs.lib.nixosSystem {
          system = linuxSystem;
          specialArgs = {
            inherit inputs;
            userConfig = getUserConfig machine;
            commonEnv = mkEnvironment { isDarwin = false; };
          };
          modules = [
            ../machines/${machine}/configuration.nix
          ];
        };
      }) machineNames
    );

  # Generate VM configurations from machine list
  mkVmConfigurations = machineNames:
    builtins.listToAttrs (
      map (machine: {
        name = machine;
        value = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = {
            inherit inputs;
            userConfig = getUserConfig machine;
            commonEnv = mkEnvironment { isDarwin = false; };
          };
          modules = [
            ../machines/${machine}/configuration.nix
          ];
        };
      }) machineNames
    );

  # Generate darwinConfigurations from machine list
  mkDarwinConfigurations = machineNames:
    builtins.listToAttrs (
      map (machine: {
        name = machine;
        value = inputs.nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit inputs;
            userConfig = getUserConfig machine;
            commonEnv = mkEnvironment { isDarwin = true; };
          };
          modules = [
            ../machines/${machine}/configuration.nix
          ];
        };
      }) machineNames
    );
}