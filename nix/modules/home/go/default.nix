{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.go;
in {
  options = {
    go.enable = mkEnableOption "Enable go";
  };
  # Configurazione del modulo
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      go
      delve
      gopls
      go-migrate
      templ
      sqlc
    ];
  };
}
