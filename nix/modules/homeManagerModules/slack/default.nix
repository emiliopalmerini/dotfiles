{ lib, config, pkgs, ... }:

let
  # Definizione delle opzioni per il modulo
  options = {
    slack.enable = lib.mkEnableOption "Enable slack";
  };
in
{
  # Configurazione del modulo
  config = lib.mkIf config.slack.enable {
    home.packages = with pkgs; [
      slack
    ];
  };
}
