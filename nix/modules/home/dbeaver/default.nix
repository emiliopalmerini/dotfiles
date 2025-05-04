{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.dbeaver;
in {
  options.dbeaver = {
    enable = mkEnableOption "Enable dbeaver module";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      dbeaver-bin
    ];
  };
}
