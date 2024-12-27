{ lib, config, pkgs, ... }:
{
  options.docker.enable = lib.mkEnableOption "Enable docker module";

  config = lib.mkIf config.docker.enable {
    virtualisation.docker.rootless = {
      enable = true;
      setSocketVariable = true;
    };

    environment.systemPackages = [
    pkgs.docker-compose
  ];
  };
}

