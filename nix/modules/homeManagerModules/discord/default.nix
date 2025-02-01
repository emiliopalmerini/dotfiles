{ lib, config, pkgs, ... }:

let
  # Definizione delle opzioni per il modulo
  options = {
    discord.enable = lib.mkEnableOption "Enable discord";
  };
in
{
  # Configurazione del modulo
  config = lib.mkIf config.discord.enable {
    home.packages = with pkgs; [
      discord
    ];
  };
}
