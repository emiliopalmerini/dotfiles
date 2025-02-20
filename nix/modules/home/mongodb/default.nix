{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.mongodb;
in
{
  options = {
    mongodb.enable = mkEnableOption "Enable MongoDB module";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      mongodb-compass
      mongosh
    ];

  };
}
