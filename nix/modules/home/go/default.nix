{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.go;
in
{
  options = {
    go.enable = mkEnableOption "Enable go";
  };
  # Configurazione del modulo
  config = mkIf config.go.enable {
    home.packages = with pkgs; [
      go
      delve
    ];
  };
}
