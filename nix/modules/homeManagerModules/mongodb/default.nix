{ lib, config, pkgs, ... }:
{
  options.mongodb.enable = lib.mkEnableOption "Enable mongodb module";

  config = lib.mkIf config.mongodb.enable {
    home.packages = [
      pkgs.mongodb-compass
    ];
  };
}

