{ lib, config, pkgs, ... }:

let
  # Definizione delle opzioni per il modulo
  options = {
    obsidian.enable = lib.mkEnableOption "Enable obsidian";
  };
in
{
  # Configurazione del modulo
  config = lib.mkIf config.obsidian.enable {
    home.packages = with pkgs; [
      obsidian
    ];
  };
}
