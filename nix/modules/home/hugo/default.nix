{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.hugo;
in
{
  options = {
    hugo.enable = mkEnableOption "Enable hugo";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      pkgs.hugo
    ];
  };
}
