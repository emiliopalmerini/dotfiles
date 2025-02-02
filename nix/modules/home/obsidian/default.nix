{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.obsidian;
in
{
  options = {
    obsidian.enable = mkEnableOption "Enable obsidian";
  };
  config = mkIf config.obsidian.enable {
    home.packages = with pkgs; [
      obsidian
    ];
  };
}
