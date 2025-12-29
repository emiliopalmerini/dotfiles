{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.docker;
in
{
  options.docker = {
    enable = mkEnableOption "Enable Docker with compose and buildx";
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

