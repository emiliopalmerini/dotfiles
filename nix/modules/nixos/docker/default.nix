{ lib, config, pkgs, ... }:

with lib;

let
  mkContOpt = name:
    mkEnableOption ("Enable Docker");

  baseDocker = {
    virtualisation.docker.rootless.enable            = true;
    virtualisation.docker.rootless.setSocketVariable = true;
    virtualisation.oci-containers.backend            = "docker";
  };
in {
  options.docker.enable =
    mkEnableOption "Enable Docker daemon in rootless mode";

  options.docker.containers.qbittorrent =
    mkContOpt "qbittorrent";

  config = mkIf config.docker.enable (
    lib.mkMerge [
      baseDocker
      {
        environment.systemPackages = with pkgs; [
          docker-compose
          lazydocker
        ];
      }
      (mkIf config.docker.containers.qbittorrent {
        virtualisation.oci-containers.containers.qbittorrent = {
          image   = "lscr.io/linuxserver/qbittorrent:latest";
          ports   = [ "127.0.0.1:8080:8080" "127.0.0.1:6881:6881" "6881:6881/udp" ];
          volumes = [
            "/var/lib/qbittorrent/downloads:/downloads"
            "/var/lib/qbittorrent/config:/config"
          ];
          autoStart    = true;
          environment = {
            PUID            = "1000";
            PGID            = "1000";
            TZ              = "Etc/UTC";
            WEBUI_PORT      = "8080";
            TORRENTING_PORT = "6881";
          };
        };
      })
    ]
  );
}

