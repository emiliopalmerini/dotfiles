{ lib, config, pkgs, ... }:
{
  options.mongodbClients.enable = lib.mkEnableOption "Enable mongodbClients module";

  config = lib.mkIf config.mongodbClients.enable {
    home.packages = [
      pkgs.mongodb-compass
      pkgs.robo3t
    ];
  };
}

