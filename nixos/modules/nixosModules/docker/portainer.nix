{ lib, config, pkgs, ... }:
{
  options.portainer.enable =
    lib.mkEnableOption "Enable portainer container";

  config = lib.mkIf config.portainer.enable {
    virtualisation.oci-containers.containers = {
      portainer = {
      };
    };
  };
}
