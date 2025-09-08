{ lib, config, ... }:

with lib;
let
  cfg = config.profiles.desktop;
in
{
  options.profiles.desktop = {
    enable = mkEnableOption "Enable desktop profile with GUI applications";
    
    browser = mkOption {
      type = types.enum [ "zen" "chrome" ];
      default = "zen";
      description = "Primary browser to enable";
    };
    
    terminal = mkOption {
      type = types.enum [ "kitty" "ghostty" ];
      default = "ghostty";
      description = "Terminal emulator to use";
    };
    
    enableProductivity = mkOption {
      type = types.bool;
      default = true;
      description = "Enable productivity applications (obsidian, todoist)";
    };
    
    enableCommunication = mkOption {
      type = types.bool;
      default = true;
      description = "Enable communication apps (telegram)";
    };
    
    enableMedia = mkOption {
      type = types.bool;
      default = false;
      description = "Enable media applications (vlc)";
    };
  };

  config = mkIf cfg.enable {
    # Browser selection - zen-browser requires special handling per host
    chrome.enable = mkIf (cfg.browser == "chrome") true;
    
    # Terminal selection
    kitty.enable = mkIf (cfg.terminal == "kitty") true;
    ghostty.enable = mkIf (cfg.terminal == "ghostty") true;
    
    # Development tools for desktop
    gcc.enable = true;
    
    # Productivity applications
    obsidian.enable = mkIf cfg.enableProductivity true;
    todoist.enable = mkIf cfg.enableProductivity true;
    
    # Communication
    telegram.enable = mkIf cfg.enableCommunication true;
    
    # Media
    vlc.enable = mkIf cfg.enableMedia true;
  };
}