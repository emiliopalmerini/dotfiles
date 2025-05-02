{ lib, config, pkgs,... }:

with lib;
let
  cfg = config.chrome;
in
{
  options.chrome = {
    enable = mkEnableOption "Enable chrome module";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      google-chrome
    ];
  };
}
