{ lib, config, ... }:

with lib;
let
  cfg = config.profiles.work;
in
{
  options.profiles.work = {
    enable = mkEnableOption "Enable work profile with business applications";
    
    enableDotnet = mkOption {
      type = types.bool;
      default = true;
      description = "Enable .NET development tools";
    };
    
    enableApiTools = mkOption {
      type = types.bool;
      default = true;
      description = "Enable API development tools (postman, bruno)";
    };
  };

  config = mkIf cfg.enable {
    # Business applications
    chrome.enable = true;
    office.enable = true;
    slack.enable = true;
    
    # Development tools
    dotnet.enable = mkIf cfg.enableDotnet true;
    
    # API development
    postman.enable = mkIf cfg.enableApiTools true;
    bruno.enable = mkIf cfg.enableApiTools true;
  };
}