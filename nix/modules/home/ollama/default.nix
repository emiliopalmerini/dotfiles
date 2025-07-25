{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.ollama;
in {
  options.ollama = {
    enable = mkEnableOption "Enable ollama module";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      ollama-cuda
    ];
  };
}
