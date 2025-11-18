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

    environment.systemPackages = [
      pkgs.docker-compose
      pkgs.docker-buildx
      pkgs.lazydocker
    ];
  };
}

