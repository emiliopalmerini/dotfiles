{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.nodejs;
in
{
  options.nodejs = {
    enable = mkEnableOption "Enable Node.js development environment";
    
    enableYarn = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Yarn package manager";
    };
    
    enablePnpm = mkOption {
      type = types.bool;
      default = false;
      description = "Enable pnpm package manager";
    };
    
    enableTypeScript = mkOption {
      type = types.bool;
      default = true;
      description = "Enable TypeScript support";
    };
    
    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "Additional Node.js packages to install";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      nodejs
      # npm is already included with nodejs, no need to install separately
    ] 
    ++ optionals cfg.enableYarn [ nodePackages.yarn ]
    ++ optionals cfg.enablePnpm [ nodePackages.pnpm ]
    ++ optionals cfg.enableTypeScript [ nodePackages.typescript ]
    ++ cfg.extraPackages;
    
    # Set up npm global directory to avoid permission issues
    home.sessionVariables = {
      NPM_CONFIG_PREFIX = "${config.home.homeDirectory}/.npm-global";
    };
    
    home.sessionPath = [
      "${config.home.homeDirectory}/.npm-global/bin"
    ];
  };
}