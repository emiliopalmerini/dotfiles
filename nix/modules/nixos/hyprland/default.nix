{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.hyprland;
in
{
  options.hyprland = {
    enable = mkEnableOption "Enable Hyprland window manager with Wayland support";

    keyboardLayout = mkOption {
      type = types.str;
      default = "us";
      description = "Keyboard layout";
    };

    keyboardVariant = mkOption {
      type = types.str;
      default = "intl";
      description = "Keyboard variant";
    };

    enablePrinting = mkOption {
      type = types.bool;
      default = true;
      description = "Enable CUPS printing support";
    };
  };

  config = mkIf cfg.enable {
    # Enable Hyprland
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    # Display manager - SDDM works well with Wayland
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    # XDG Portal for screen sharing and other desktop integration
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
      configPackages = [ pkgs.hyprland ];
    };

    # Audio configuration (PipeWire)
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Disable PulseAudio in favor of PipeWire
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;

    # Printing support
    services.printing.enable = mkIf cfg.enablePrinting true;

    # Input configuration
    services.xserver = {
      enable = true;
      xkb = {
        layout = cfg.keyboardLayout;
        variant = cfg.keyboardVariant;
      };
    };

    # Useful packages for Hyprland environment
    environment.systemPackages = with pkgs; [
      # Wayland utilities
      wl-clipboard # Clipboard utilities
      grim # Screenshot utility
      slurp # Screen area selection

      # System utilities
      brightnessctl # Backlight control
      playerctl # Media player control

      # Qt theming for Wayland
      qt5.qtwayland
      qt6.qtwayland
    ];

    # Enable polkit for privilege escalation
    security.polkit.enable = true;
  };
}
