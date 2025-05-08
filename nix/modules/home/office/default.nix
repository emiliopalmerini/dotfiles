{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.office;
in {
  options.office = {
    enable = mkEnableOption "Enable office module";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      libreoffice
    ];
  };
}
