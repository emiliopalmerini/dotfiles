{ lib, config, pkgs, inputs, ... }:

with lib;
let
  cfg = config.warp;
in
{
  options.warp = {
    enable = mkEnableOption "Enable warp module";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      warp-terminal
    ];
  };
}
