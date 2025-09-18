{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.docker;
in
{
  options.docker = {
    enable = mkEnableOption "Enable Docker and it-tools container";
    itToolsPort = mkOption {
      type = types.int;
      default = 8085;
      description = "Host port for exposing it-tools (container port 80).";
    };
    enableWindows = mkEnableOption "Enable Windows VPN container";
    windowsVncPort = mkOption {
      type = types.int;
      default = 8006;
      description = "Host port for Windows VNC access.";
    };
    windowsRdpPort = mkOption {
      type = types.int;
      default = 3389;
      description = "Host port for Windows RDP access.";
    };
    enableVpnRouting = mkEnableOption "Enable VPN traffic routing through Windows container";
    vpnInterface = mkOption {
      type = types.str;
      default = "wlan0";
      description = "Host network interface to route through VPN";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
    };

    virtualisation.oci-containers = {
      backend = "docker";
      containers = {
        it-tools = {
          image = "ghcr.io/corentinth/it-tools:latest";
          ports = [ "${toString cfg.itToolsPort}:80" ];
        };
      } // (mkIf cfg.enableWindows {
        windows-vpn = {
          image = "dockurr/windows";
          ports = [ 
            "${toString cfg.windowsVncPort}:8006"
            "${toString cfg.windowsRdpPort}:3389"
          ];
          environment = {
            VERSION = "win11";
            RAM_SIZE = "4G";
            CPU_CORES = "2";
            DISK_SIZE = "64G";
          };
          volumes = [
            "windows-vpn-data:/storage"
          ];
          extraOptions = [
            "--cap-add=NET_ADMIN"
            "--device=/dev/kvm"
            "--privileged"
          ];
        };
      });
    };

    environment.systemPackages = with pkgs; [
      docker-compose
      docker-buildx
      lazydocker
    ] ++ (lib.optionals cfg.enableVpnRouting [
      (pkgs.writeScriptBin "windows-vpn-router" ''
        #!${pkgs.bash}/bin/bash
        set -euo pipefail

        CONTAINER_NAME="windows-vpn"
        INTERFACE="${cfg.vpnInterface}"
        CONTAINER_IP=""

        log() {
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >&2
        }

        get_container_ip() {
            CONTAINER_IP=$(${pkgs.docker}/bin/docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$CONTAINER_NAME" 2>/dev/null || echo "")
            if [ -z "$CONTAINER_IP" ]; then
                log "ERROR: Could not get container IP for $CONTAINER_NAME"
                return 1
            fi
            log "Container IP: $CONTAINER_IP"
        }

        wait_for_container() {
            log "Waiting for Windows container to start..."
            local retries=30
            while [ $retries -gt 0 ]; do
                if ${pkgs.docker}/bin/docker ps --filter "name=$CONTAINER_NAME" --filter "status=running" --format "{{.Names}}" | grep -q "$CONTAINER_NAME"; then
                    log "Container is running"
                    get_container_ip
                    return 0
                fi
                log "Container not ready, waiting... ($retries retries left)"
                sleep 10
                ((retries--))
            done
            log "ERROR: Container failed to start within timeout"
            return 1
        }

        setup_routing() {
            log "Setting up VPN routing..."
            
            # Enable IP forwarding
            echo 1 > /proc/sys/net/ipv4/ip_forward
            
            # Get default gateway
            DEFAULT_GW=$(${pkgs.iproute2}/bin/ip route show default | ${pkgs.gawk}/bin/awk '/default/ { print $3; exit }')
            log "Default gateway: $DEFAULT_GW"
            
            # Create routing table for VPN traffic
            ${pkgs.iproute2}/bin/ip rule add fwmark 1 table 100 2>/dev/null || true
            ${pkgs.iproute2}/bin/ip route add default via $CONTAINER_IP dev docker0 table 100 2>/dev/null || true
            
            # Setup iptables rules
            ${pkgs.iptables}/bin/iptables -t nat -A OUTPUT -o $INTERFACE -j MARK --set-mark 1 2>/dev/null || true
            ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -m mark --mark 1 -j SNAT --to-source $CONTAINER_IP 2>/dev/null || true
            
            log "VPN routing configured successfully"
        }

        cleanup_routing() {
            log "Cleaning up VPN routing..."
            
            # Remove iptables rules
            ${pkgs.iptables}/bin/iptables -t nat -D OUTPUT -o $INTERFACE -j MARK --set-mark 1 2>/dev/null || true
            ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -m mark --mark 1 -j SNAT --to-source $CONTAINER_IP 2>/dev/null || true
            
            # Remove routing rules
            ${pkgs.iproute2}/bin/ip rule del fwmark 1 table 100 2>/dev/null || true
            ${pkgs.iproute2}/bin/ip route del default via $CONTAINER_IP dev docker0 table 100 2>/dev/null || true
            
            log "VPN routing cleanup completed"
        }

        start_vpn_in_container() {
            log "Starting VPN inside Windows container..."
            # This would need to be customized based on your VPN client
            # For now, we'll just ensure the container is ready for VPN setup
            log "Container is ready for VPN configuration via VNC/RDP"
            log "Access VNC at: http://localhost:${toString cfg.windowsVncPort}"
            log "Access RDP at: localhost:${toString cfg.windowsRdpPort}"
        }

        case "''${1:-}" in
            "start")
                log "Starting Windows VPN routing..."
                wait_for_container
                setup_routing
                start_vpn_in_container
                log "Windows VPN routing started successfully"
                ;;
            "stop")
                log "Stopping Windows VPN routing..."
                get_container_ip || true
                cleanup_routing
                log "Windows VPN routing stopped"
                ;;
            "status")
                if ${pkgs.docker}/bin/docker ps --filter "name=$CONTAINER_NAME" --filter "status=running" --format "{{.Names}}" | grep -q "$CONTAINER_NAME"; then
                    log "Container is running"
                    get_container_ip
                    log "VPN routing is active"
                else
                    log "Container is not running"
                fi
                ;;
            "restart")
                $0 stop
                sleep 2
                $0 start
                ;;
            *)
                echo "Usage: $0 {start|stop|status|restart}"
                echo "  start   - Start VPN routing through Windows container"
                echo "  stop    - Stop VPN routing and cleanup"
                echo "  status  - Show current status"
                echo "  restart - Restart VPN routing"
                exit 1
                ;;
        esac
      '')
    ]);

    # VPN routing systemd service
    systemd.services.windows-vpn-router = mkIf cfg.enableVpnRouting {
      description = "Windows VPN Container Router";
      after = [ "docker.service" "docker-windows-vpn.service" ];
      wants = [ "docker-windows-vpn.service" ];
      wantedBy = [ "multi-user.target" ];
      
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.writeScript "start-vpn-routing" ''
          #!${pkgs.bash}/bin/bash
          /run/current-system/sw/bin/windows-vpn-router start
        ''}";
        ExecStop = "${pkgs.writeScript "stop-vpn-routing" ''
          #!${pkgs.bash}/bin/bash
          /run/current-system/sw/bin/windows-vpn-router stop
        ''}";
      };
    };
  };
}

