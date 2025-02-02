{ lib, config, pkgs, inputs, ... }:

with lib;
let
  cfg = config.obs;
in
{
  options.obs = {
    enable = mkEnableOption "Enable obs module";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      obs-studio
    ];
  };
}
