{ lib, config, pkgs, ... }:
{
  options.homer.enable =
    lib.mkEnableOption "Enable homer container";

  config = lib.mkIf config.homer.enable {
    virtualisation.oci-containers.containers = {
      homer_olimpo = {
        autoStart = true;
        image = "b4bz/homer";
        containerName = "homer";
        volumes = [
          { hostPath = ./homer/assets; containerPath = "/www/assets"; }
        ];
        ports = [
          { hostPort = 7042; containerPort = 8080; }
        ];
        user = "1000:1000"; # default
        environment = {
          INIT_ASSETS = "1"; # default
        };
      };

      code-server = {
        autoStart = true;
        image = "lscr.io/linuxserver/code-server:latest";
        containerName = "code-server";
        environment = {
          PUID = "1000";
          PGID = "1000";
          TZ = "Etc/UTC";
          PASSWORD = "password";
        };
        volumes = [
          { hostPath = ./code-server/config; containerPath = "/config"; }
          { hostPath = ./homer/assets; containerPath = "/config/homer"; }
        ];
        ports = [
          { hostPort = 8443; containerPort = 8443; }
        ];
        restart = "always";
      };
    };
  };
}
