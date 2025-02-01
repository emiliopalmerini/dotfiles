{ lib, config, pkgs, ... }:
let
  cfg = config.homeAssistant;
in
{
  options.homeAssistant.enable =
    lib.mkEnableOption "Enable homeAssistant container";

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers = {
      homeassistant = {
        volumes = [ "home-assistant:/config" ];
        environment.TZ = "Europe/Rome";
        image = "ghcr.io/home-assistant/home-assistant:stable"; # Warning: if the tag does not change, the image will not be updated
        extraOptions = [ 
          "--network=host" 
          #"--device=/dev/ttyACM0:/dev/ttyACM0"  # Example, change this to match your own hardware
        ];
      };
    };
      networking.firewall.allowedTCPPorts = [ 8123 ];
  };
}

