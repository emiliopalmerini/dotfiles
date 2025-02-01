{ lib, config, pkgs, ... }:

let
  # Definizione delle opzioni per il modulo
  options = {
    todoist.enable = lib.mkEnableOption "Enable todoist";
  };
in
{
  # Configurazione del modulo
  config = lib.mkIf config.todoist.enable {
    home.packages = with pkgs; [
      todoist
    ];
  };
}
