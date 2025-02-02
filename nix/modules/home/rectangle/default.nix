{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.rectangle;
in
{
  options = {
    rectangle.enable = mkEnableOption "Enable rectangle";
  };
  config = mkIf config.rectangle.enable {
    home.packages = with pkgs; [
      rectangle
    ];
  };
}
