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
      mongosh
      mongodb-tools
    ] ++ lib.optionals (pkgs.stdenv.hostPlatform.system != "aarch64-linux") [
      # mongodb-compass is not available on aarch64-linux
      mongodb-compass
    ];

  };
}
