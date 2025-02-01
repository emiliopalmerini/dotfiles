{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.kitty;
in
{
  # Definizione delle opzioni per il modulo Kitty
  options = {
    kitty.enable = mkEnableOption "Enable Kitty terminal emulator module";
  };

  # Configurazione del modulo Kitty
  config = mkIf cfg.enable {
    programs.kitty.enable = true;

    # Puoi aggiungere ulteriori configurazioni per Kitty qui
    # Esempio:
    # programs.kitty.fonts = {
    #   normal = "YourFontName";
    #   bold = "YourBoldFontName";
    # };
  };
}
