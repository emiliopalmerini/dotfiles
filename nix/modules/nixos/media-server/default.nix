{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.media-server;
in
{
  options.media-server = {
    enable = mkEnableOption "Enable media server suite (Plex, qBittorrent)";
    
    plex = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable Plex Media Server";
      };
      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/plex";
        description = "Plex data directory";
      };
    };

    qbittorrent = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable qBittorrent";
      };
      webUIPort = mkOption {
        type = types.int;
        default = 8080;
        description = "qBittorrent Web UI port";
      };
      torrentingPort = mkOption {
        type = types.int;
        default = 6881;
        description = "qBittorrent torrenting port";
      };
    };


  };

  config = mkIf cfg.enable {
    # Plex Media Server
    services.plex = mkIf cfg.plex.enable {
      enable = true;
      dataDir = cfg.plex.dataDir;
      openFirewall = true;
      user = "plex";
      group = "plex";
    };

    # qBittorrent configuration
    services.qbittorrent = mkIf cfg.qbittorrent.enable {
      enable = true;
      profileDir = "/var/lib/qbittorrent";
      openFirewall = true;
      webuiPort = cfg.qbittorrent.webUIPort;
      torrentingPort = cfg.qbittorrent.torrentingPort;
      serverConfig = {
        Preferences = {
          Downloads = {
            SavePath = "${cfg.plex.dataDir}/movies/";
          };
          WebUI = {
            Address = "0.0.0.0";
          };
        };
        Categories = {
          movies = { SavePath = "${cfg.plex.dataDir}/movies/"; SavePathEnabled = true; };
          tv = { SavePath = "${cfg.plex.dataDir}/tv/"; SavePathEnabled = true; };
          music = { SavePath = "${cfg.plex.dataDir}/music/"; SavePathEnabled = true; };
        };
        LegalNotice = { Accepted = true; };
      };
    };



    # Additional configuration for qBittorrent and Plex integration
    systemd.services.qbittorrent.serviceConfig = mkIf cfg.qbittorrent.enable {
      UMask = "0002";
    };

    users.users = mkIf cfg.qbittorrent.enable {
      qbittorrent.extraGroups = [ "plex" ];
    };

    # Directory structure and permissions
    systemd.tmpfiles.rules = mkIf cfg.enable [
      # qBittorrent
      "d /var/lib/qbittorrent 0755 qbittorrent qbittorrent -"
      # Plex libraries (setgid to maintain group)
      "d ${cfg.plex.dataDir} 2775 root plex -"
      "d ${cfg.plex.dataDir}/tv 2775 root plex -"
      "d ${cfg.plex.dataDir}/movies 2775 root plex -"
      "d ${cfg.plex.dataDir}/music 2775 root plex -"
    ];


  };
}