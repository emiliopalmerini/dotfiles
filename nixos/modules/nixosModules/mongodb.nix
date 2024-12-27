{ lib, config, pkgs, ... }:
{
  options.mongodb.enable = lib.mkEnableOption "Enable mongodb module";

  config = lib.mkIf config.mongodb.enable {
    environment.systemPackages = [
      pkgs.mongodb
      pkgs.mongodb-compass
      pkgs.robo3t
    ];
  };
}

