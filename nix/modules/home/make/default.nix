{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.make;
in
{
  options = {
    make.enable = mkEnableOption "Enable make module";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gnumake
    ];

  };
}
