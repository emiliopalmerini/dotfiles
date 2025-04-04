{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.gimp;
in
{
  options.gimp = {
    enable = mkEnableOption "Enable gimp module";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gimp
    ];
  };
}
