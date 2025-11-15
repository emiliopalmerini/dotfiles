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
      };
    };

    environment.systemPackages = [
      pkgs.docker-compose
      pkgs.docker-buildx
      pkgs.lazydocker
    ];
  };
}

