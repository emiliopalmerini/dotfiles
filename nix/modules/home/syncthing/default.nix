{ lib, config, pkgs, inputs, ... }:

with lib;
let
  cfg = config.syncthing;
in
{
  options.syncthing = {
    enable = mkEnableOption "Enable syncthing module";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      syncthing
    ];
  };
}
