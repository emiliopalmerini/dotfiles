{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.vlc;
in {
  options.vlc = {
    enable = mkEnableOption "Enable vlc module";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      vlc
    ];
  };
}
