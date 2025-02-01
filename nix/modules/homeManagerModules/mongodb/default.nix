{ lib, config, pkgs, ... }:

let
  options = {
    myPackage.enable = lib.mkEnableOption "Enable MongoDB module";
  };
in
{
  # Configurazione del modulo
  config = lib.mkIf config.myPackage.enable {
    home.packages = [
      pkgs.mongodb          # Aggiungi il pacchetto MongoDB
      pkgs.mongodb-compass  # Aggiungi il pacchetto MongoDB Compass
    ];

    # Puoi aggiungere ulteriori configurazioni per MongoDB qui
    # Esempio:
    # services.mongodb.enable = true;
  };
}
