{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.MODULE;
in {
  options.MODULE = {
    enable = mkEnableOption "Enable MODULE module";
  };

  config = mkIf cfg.enable {};
}
