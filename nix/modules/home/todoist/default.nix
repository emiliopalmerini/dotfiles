{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.todoist;
in
{
  options = {
    todoist.enable = mkEnableOption "Enable todoist";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      todoist
    ];
  };
}
