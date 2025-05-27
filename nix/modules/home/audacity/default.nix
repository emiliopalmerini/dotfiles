{
  lib,
  config,
pkgs,
  ...
}:
with lib; let
  cfg = config.audacity;
in {
  options.audacity = {
    enable = mkEnableOption "Enable audacity module";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      audacity
    ];
  };
}
