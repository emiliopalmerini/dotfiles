{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.gnome-desktop;
in
{
  options.gnome-desktop = {
    enable = mkEnableOption "Enable GNOME desktop environment with common configuration";
    
    keyboardLayout = mkOption {
      type = types.str;
      default = "us";
      description = "X server keyboard layout";
    };
    
    keyboardVariant = mkOption {
      type = types.str;
      default = "intl";
      description = "X server keyboard variant";
    };
    
    enablePrinting = mkOption {
      type = types.bool;
      default = true;
      description = "Enable CUPS printing support";
    };
  };

  config = mkIf cfg.enable {
    services = {
      # X server and keyboard
      xserver = {
        enable = true;
        xkb = {
          layout = cfg.keyboardLayout;
          variant = cfg.keyboardVariant;
        };
      };

      # Display manager and desktop environment
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;

      # Audio configuration
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };

      # Printing support
      printing.enable = mkIf cfg.enablePrinting true;
    };

    # Disable PulseAudio in favor of PipeWire
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;

    # Remove unwanted GNOME packages
    environment.gnome.excludePackages = [
      pkgs.atomix # puzzle game
      pkgs.cheese # webcam tool
      pkgs.epiphany # web browser
      pkgs.evince # document viewer
      pkgs.geary # email reader
      pkgs.gedit # text editor
      pkgs.gnome-characters
      pkgs.gnome-music
      pkgs.gnome-photos
      pkgs.gnome-terminal
      pkgs.gnome-tour
      pkgs.hitori # sudoku game
      pkgs.iagno # go game
      pkgs.tali # poker game
      pkgs.totem # video player
    ];
  };
}