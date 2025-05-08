{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.postman;
in {
  options.postman = {
    enable = mkEnableOption "Enable postman module";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      postman
    ];
  };
}
