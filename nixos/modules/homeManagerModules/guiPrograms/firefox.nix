{ lib, config, pkgs, ... }:

let
  cfg = config.firefox;
in
{
  options.firefox = {
    enable = lib.mkEnableOption "enable firefox module";
  };

    config = lib.mkIf cfg.enable {
      programs.firefox.enable = true;
    };
}
