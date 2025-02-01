{ lib, config, pkgs, inputs, ... }:

with lib;
let
  cfg = config.gcc;
in
{
  options.gcc = {
    enable = mkEnableOption "Enable gcc module";
  };

  config = mkIf cfg.enable {
      home.packages = with pkgs; [
        gcc
      ];
  };
}
