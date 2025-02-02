{ lib, config, pkgs, inputs, ... }:

with lib;
let
  cfg = config.firefox;
in
{
  options.firefox = {
    enable = mkEnableOption "Enable firefox module";
  };

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
    };
  };
}
