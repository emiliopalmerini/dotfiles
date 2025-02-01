{ lib, config, pkgs, ... }:

let
  # Definizione delle opzioni per il modulo
  options = {
    gimp.enable = lib.mkEnableOption "Enable gimp";
  };
in
{
  # Configurazione del modulo
  config = lib.mkIf config.gimp.enable {
    home.packages = with pkgs; [
      gimp
    ];
  };
}
