{ lib, config, pkgs, inputs, ... }:

with lib;
let
  cfg = config.unityhub;
in
{
  options.unityhub = {
    enable = mkEnableOption "Enable unityhub module";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      unityhub
    ];
  };
}
