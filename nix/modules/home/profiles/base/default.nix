{ lib, config, userConfig, ... }:

with lib;
let
  cfg = config.profiles.base;
in
{
  options.profiles.base = {
    enable = mkEnableOption "Enable base home configuration profile";
    
    gitUserName = mkOption {
      type = types.str;
      default = "emiliopalmerini";
      description = "Git username";
    };
    
    stateVersion = mkOption {
      type = types.str;
      default = "24.11";
      description = "Home Manager state version";
    };
  };

  config = mkIf cfg.enable {
    # Standard boilerplate configuration
    home.username = userConfig.username;
    home.homeDirectory = userConfig.homeDirectory;
    home.stateVersion = cfg.stateVersion;
    
    nixpkgs.config.allowUnfree = true;
    programs.home-manager.enable = true;
    
    # Git configuration with user-specific email
    git.enable = true;
    git.userEmail = userConfig.email;
    git.userName = cfg.gitUserName;
  };
}