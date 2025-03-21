{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.postgres;
in
{
  options.postgres = {
    enable = mkEnableOption "Enable postgres module";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      postgresql_17
    ];
  };
}
