{ lib, config, pkgs, ... }:

with lib;

let
  mkContOpt = name:
    mkEnableOption ("Enable Docker");

in {
  options.docker.enable =
    mkEnableOption "Enable Docker daemon in rootless mode";

  config = mkIf config.docker.enable {
    virtualisation.docker.rootless.enable            = true;
    virtualisation.docker.rootless.setSocketVariable = true;
    virtualisation.oci-containers.backend            = "docker";
    environment.systemPackages = with pkgs; [
    docker-compose
    lazydocker
  ];
  };
}

