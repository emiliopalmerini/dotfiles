{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.pdf2md;
in {
  options.pdf2md = {
    enable = mkEnableOption "Enable pdf2md module";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      pdf2md
    ];
  };
}