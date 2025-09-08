{ lib, config, ... }:

with lib;
let
  cfg = config.tailscale-only-access;
in
{
  options.tailscale-only-access = {
    enable = mkEnableOption "Enable Tailscale-only access configuration for homelab servers";
    
    tailscaleInterface = mkOption {
      type = types.str;
      default = "tailscale0";
      description = "Tailscale network interface name";
    };
    
    allowLocalNetwork = mkOption {
      type = types.bool;
      default = false;
      description = "Allow access from local network";
    };
    
    localNetworkInterface = mkOption {
      type = types.str;
      default = "eth0";
      description = "Local network interface (if allowLocalNetwork is enabled)";
    };
  };

  config = mkIf cfg.enable {
    # Enable Tailscale
    services.tailscale.enable = true;
    
    # Firewall configuration - block everything except Tailscale
    networking.firewall = {
      enable = true;
      
      # Trust the Tailscale interface completely
      trustedInterfaces = [ cfg.tailscaleInterface ] 
        ++ optionals cfg.allowLocalNetwork [ cfg.localNetworkInterface ];
      
      # Block all external ports - only Tailscale can access
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ 41641 ]; # Tailscale coordination port
      
      # Allow outbound connections (for updates, etc.)
      # No need to configure - NixOS firewall is stateful
    };
    
    # SSH configuration - will only be accessible via Tailscale due to firewall
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        X11Forwarding = false;
      };
    };
    
    # All services (nginx, plex, qbittorrent, etc.) can bind to 0.0.0.0
    # The firewall will ensure only Tailscale traffic reaches them
  };
}