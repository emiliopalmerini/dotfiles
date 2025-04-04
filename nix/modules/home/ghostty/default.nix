{ lib, config, pkgs, ... }:

let
  cfg = config.ghostty;
in
{
  options.ghostty = {
    enable = lib.mkEnableOption "Enable ghostty module";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ ghostty ];
  };
}
