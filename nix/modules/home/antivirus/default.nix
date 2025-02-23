{ lib, config, pkgs, inputs, ... }:

with lib;
let
  cfg = config.antivirus;
in
{
  options.antivirus = {
    enable = mkEnableOption "Enable antivirus module";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      clamav 
    ];
  };
}
