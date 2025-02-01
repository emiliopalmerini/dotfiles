{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.lua;

in {
  # Definizione delle opzioni per il modulo Lua
  options.modules.lua = {
    enable = mkEnableOption "Enable Lua programming language";
  };

  # Configurazione del modulo Lua
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      pkgs.lua  # Aggiungi il pacchetto Lua
    ];

    # Puoi aggiungere ulteriori configurazioni per Lua qui
    # Esempio:
    # programs.lua.someOption = true;
  };
}

