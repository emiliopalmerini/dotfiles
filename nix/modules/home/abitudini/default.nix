{ lib
, config
, pkgs
, inputs
, ...
}:
with lib; let
  cfg = config.abitudini;
in
{
  options = {
    abitudini.enable = mkEnableOption "Enable abitudini";
  };
  config = mkIf cfg.enable {
    home.packages = [
      inputs.abitudini.packages.${pkgs.stdenv.system}.abitudini
    ];
  };
}
