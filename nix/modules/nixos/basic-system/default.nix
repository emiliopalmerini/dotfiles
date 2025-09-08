{ lib, config, ... }:

with lib;
let
  cfg = config.basic-system;
in
{
  options.basic-system = {
    enable = mkEnableOption "Enable basic system configuration";
    
    enableBootloader = mkOption {
      type = types.bool;
      default = true;
      description = "Enable systemd-boot bootloader configuration";
    };
    
    enableNetworkManager = mkOption {
      type = types.bool;
      default = true;
      description = "Enable NetworkManager for network configuration";
    };
    
    nixGcDays = mkOption {
      type = types.str;
      default = "weekly";
      description = "How often to run nix garbage collection";
    };
    
    nixGcKeepDays = mkOption {
      type = types.str;
      default = "30d";
      description = "How long to keep old generations";
    };
  };

  config = mkIf cfg.enable {
    # Bootloader configuration
    boot = mkIf cfg.enableBootloader {
      loader.systemd-boot.enable = true;
      loader.efi.canTouchEfiVariables = true;
    };

    # Network configuration
    networking.networkmanager.enable = mkIf cfg.enableNetworkManager true;

    # Nix configuration
    nix = {
      gc = {
        automatic = true;
        dates = cfg.nixGcDays;
        options = "--delete-older-than ${cfg.nixGcKeepDays}";
      };
      settings = {
        auto-optimise-store = true;
        experimental-features = [ "nix-command" "flakes" ];
      };
    };

    # Basic programs
    programs.zsh.enable = true;
    
    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;
  };
}