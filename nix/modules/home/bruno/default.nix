{ lib, config, pkgs, inputs, ... }:

with lib;
let
  cfg = config.bruno;
in
{
  options.bruno = {
    enable = mkEnableOption "Enable bruno module";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      bruno
    ];
  };
}
