{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.lazydocker;
in
{
  options = {
    lazydocker.enable = mkEnableOption "Enable lazydocker";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      lazydocker
    ];
  };
}
