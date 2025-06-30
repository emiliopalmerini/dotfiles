{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.cursor;
in {
  options.cursor = {
    enable = mkEnableOption "Enable cursor module";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      code-cursor
    ];
  };
}
