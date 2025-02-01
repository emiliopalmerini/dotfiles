{ lib, config, pkgs, ... }:

{
  # Definizione delle opzioni per il modulo Kitty
  options = {
    kitty.enable = lib.mkEnableOption "Enable Kitty terminal emulator module";
  };

  # Configurazione del modulo Kitty
  config = lib.mkIf config.kitty.enable {
    programs.kitty.enable = true;

    # Puoi aggiungere ulteriori configurazioni per Kitty qui
    # Esempio:
    # programs.kitty.fonts = {
    #   normal = "YourFontName";
    #   bold = "YourBoldFontName";
    # };
  };
}
