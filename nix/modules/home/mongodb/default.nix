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
    home.packages = [
      pkgs.mongosh
      pkgs.mongodb-tools
    ] ++ lib.optionals (!pkgs.stdenv.isDarwin && pkgs.stdenv.hostPlatform.system != "aarch64-linux") [
      pkgs.mongodb-compass
    ];
  };
}
