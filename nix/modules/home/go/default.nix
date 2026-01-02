{ lib
, config
, pkgs
, ...
}:
with lib; let
  cfg = config.go;
in
{
  options = {
    go.enable = mkEnableOption "Enable go";
  };
  config = mkIf cfg.enable {
    home.packages = [
      pkgs.go
      pkgs.delve
      pkgs.gopls
      pkgs.go-migrate
      pkgs.templ
      pkgs.sqlc
      pkgs.air
      pkgs.hey
      pkgs.go-tools # includes benchstat
    ];
  };
}
