{ lib, config, pkgs, ... }:

let
  # Definizione delle opzioni per il modulo
  options = {
    rectangle.enable = lib.mkEnableOption "Enable rectangle";
  };
in
{
  # Configurazione del modulo
  config = lib.mkIf config.rectangle.enable {
    home.packages = with pkgs; [
      rectangle
    ];
  };
}
