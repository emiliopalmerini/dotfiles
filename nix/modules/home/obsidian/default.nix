{ lib, config, pkgs, ... }:

with lib;
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
