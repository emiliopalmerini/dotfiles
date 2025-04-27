{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.discord;
in
{
  options.discord = {
    enable = mkEnableOption "Enable discord module";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      legcord
    ];
  };
}
