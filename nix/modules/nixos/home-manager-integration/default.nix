{ lib, config, inputs, userConfig, ... }:

with lib;
let
  cfg = config.home-manager-integration;
in
{
  options.home-manager-integration = {
    enable = mkEnableOption "Enable Home Manager integration with standard configuration";
    
    backupFileExtension = mkOption {
      type = types.str;
      default = "bak";
      description = "Extension for backup files created by Home Manager";
    };
    
    homeConfigPath = mkOption {
      type = types.str;
      default = "./home.nix";
      description = "Path to the home.nix configuration file";
    };
  };

  config = mkIf cfg.enable {
    home-manager = {
      extraSpecialArgs = { 
        inherit inputs userConfig; 
      };
      users = {
        "${userConfig.username}" = import cfg.homeConfigPath;
      };
      backupFileExtension = cfg.backupFileExtension;
    };
  };
}