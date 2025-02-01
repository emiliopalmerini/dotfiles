{ lib, config, pkgs, ... }:

let
  # Definizione delle opzioni per lazygit
  options = {
    lazygit.enable = lib.mkEnableOption "Enable lazygit";
  };
in
{
  # Configurazione di lazygit
  config = lib.mkIf config.lazygit.enable {
    home.packages = with pkgs; [
      pkgs.lazygit  # Aggiungi il pacchetto lazygit
    ];

    # Puoi aggiungere ulteriori configurazioni per lazygit qui
    # Esempio:
    # programs.lazygit.someOption = true;
  };
}
