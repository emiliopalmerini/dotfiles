{ lib, config, pkgs, ... }:

let
  # Definizione delle opzioni per il modulo
  options = {
    bruno.enable = lib.mkEnableOption "Enable bruno";
  };
in
{
  # Configurazione del modulo
  config = lib.mkIf config.bruno.enable {
    home.packages = [
      pkgs.bruno
    ];
  };
}
