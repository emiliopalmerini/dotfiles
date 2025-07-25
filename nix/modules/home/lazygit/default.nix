{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.lazygit;
in
{
  options = {
    lazygit.enable = mkEnableOption "Enable lazygit";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      lazygit
      xclip
    ];
  };
}
