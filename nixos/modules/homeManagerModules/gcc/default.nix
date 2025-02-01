{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.gcc;

in {
    options.modules.gcc = { enable = mkEnableOption "gcc"; };
    config = mkIf cfg.enable {
      home.packages = with pkgs; [
        gcc
      ];
    };
}
