{ lib, config, pkgs, ... }:
{
  imports = [
    ./homer
  ];
  options.docker.enable = lib.mkEnableOption "Enable docker module";

  config = lib.mkIf config.docker.enable {
    virtualisation.docker.rootless = {
      enable = true;
      setSocketVariable = true;
    };

    virtualisation.oci-containers = {
      backend = "docker";
    };

    homer.enable = true;

    environment.systemPackages = with pkgs; [
      docker-compose
      lazydocker
  ];
  };
}

