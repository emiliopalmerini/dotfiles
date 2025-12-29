{ inputs, nixpkgs, ... }:
let
  userLib = import ./users.nix;
  commonLib = import ./common.nix;
in
rec {
  users = userLib.users;
  getUserConfig = userLib.getUserConfig;
  inherit (commonLib) mkEnvironment;

  # Generate NixOS configurations with specified system architecture
  mkNixosConfigurations = { machineNames, system ? "x86_64-linux" }:
    builtins.listToAttrs (
      map (machine: {
        name = machine;
        value = nixpkgs.lib.nixosSystem {
          inherit system;
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

  # Generate Darwin configurations
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