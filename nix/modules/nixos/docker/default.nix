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
    dnsServers = mkOption {
      type = with types; listOf str;
      default = [ "1.1.1.1" "8.8.8.8" ];
      description = "DNS servers for Docker daemon and containers.";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      # Valido anche in rootless: genera daemon.json con i DNS
      daemon.settings = {
        dns = cfg.dnsServers;
      };
    };

    virtualisation.oci-containers = {
      backend = "docker";
      containers = {
        it-tools = {
          image = "ghcr.io/corentinth/it-tools:latest";
          ports = [ "${toString cfg.itToolsPort}:80" ];
          # Ridondante ma utile: passa i DNS anche al run
          extraOptions = concatMap (d: [ "--dns=${d}" ]) cfg.dnsServers;
        };
      };
    };

    environment.systemPackages = with pkgs; [
      docker-compose
      lazydocker
    ];
  };
}

