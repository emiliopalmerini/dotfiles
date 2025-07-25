{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.codex;
in {
  options.codex = {
    enable = mkEnableOption "Enable codex module";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      claude-code
    ];
  };
}
