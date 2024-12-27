{ lib, config, pkgs, ... }:
{
  options.mongodbClients.enable = lib.mkEnableOption "Enable mongodbClients module";

  config = lib.mkIf config.mongodbClients.enable {
    environment.systemPackages = [
      pkgs.mongodb-compass
      pkgs.robo3t
    ];
  };
}

