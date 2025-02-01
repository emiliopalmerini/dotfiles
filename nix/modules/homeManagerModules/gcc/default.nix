{ lib, config, pkgs, ... }:

let
  # Definizione delle opzioni per il modulo
  options = {
    gcc.enable = lib.mkEnableOption "Enable gcc";
  };
in
{
  # Configurazione del modulo
  config = lib.mkIf config.gcc.enable {
      home.packages = [
        pkgs.gcc
      ];
  };
}
