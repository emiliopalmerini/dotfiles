{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.slack;
in
{
  options = {
    slack.enable = mkEnableOption "Enable slack";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      slack
    ];
  };
}
