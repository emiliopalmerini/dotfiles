{ lib, config, pkgs, ... }:

let
  # Definizione delle opzioni per il modulo
  options = {
    firefox.enable = lib.mkEnableOption "Enable firefox";
  };
in
{
  # Configurazione del modulo
  config = lib.mkIf config.firefox.enable {
      programs.firefox.enable = true;
  };
}
