{ lib, config, pkgs, ... }:

{
  options = {
    obsidian.enable = 
      lib.mkEnableOption "enable obsidian";
  };

    config = lib.mkIf config.obsidian.enable {
    home.packages = with pkgs; [
      obsidian
    ];
    };
}
