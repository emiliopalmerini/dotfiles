{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.slack;

in {
  options.modules.slack = { enable = mkEnableOption "slack"; };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      slack
    ];
  };
}
