{ lib, config, pkgs, ... }:
let
  cfg = config.homer;
in
{
  options = {
    homer.enable =
    lib.mkEnableOption "Enable homer container";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers = {
      homer_olimpo = {
        autoStart = true;
        image = "b4bz/homer";
        ports = ["7042:8080"];
        volumes = [
          "./homer/assets:/www/assets"
        ];
        user = "1000:1000"; # default
        environment = {
          INIT_ASSETS = "1"; # default
        };
      };
    };
  };
}
