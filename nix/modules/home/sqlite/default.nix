{ lib, config, pkgs, inputs, ... }:

with lib;
let
  cfg = config.sqlite;
in
{
  options.sqlite = {
    enable = mkEnableOption "Enable sqlite module";
  };

  config = mkIf cfg.enable {
  };
}
