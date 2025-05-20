{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.wget;
in {
  options.wget = {
    enable = mkEnableOption "Enable wget module";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      wget
    ];
  };
}
