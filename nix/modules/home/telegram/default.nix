{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.telegram;
in
{
  options = {
    telegram.enable 
      = mkEnableOption "enable telegram";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      telegram-desktop
    ];
  };
}
