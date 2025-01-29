{ lib, config, pkgs, ... }:
{
  imports = [
    ./homeAssistant.nix
    ./homer.nix
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

    homeAssistant.enable = true;
    homer.enable = true;

    environment.systemPackages = with pkgs; [
      docker-compose
      lazydocker
  ];
  };
}

