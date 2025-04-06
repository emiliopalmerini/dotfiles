{ lib, config, pkgs, inputs, ... }:

with lib;
let
  cfg = config.arc-browser;
in
{
  options.arc-browser = {
    enable = mkEnableOption "Enable arc-browser module";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.arc-browser];
  };
}
