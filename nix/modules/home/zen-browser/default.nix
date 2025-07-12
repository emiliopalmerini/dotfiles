{ lib, config, pkgs, inputs, ... }:

with lib;
let
  cfg = config.zen-browser;
in
{
  options.zen-browser = {
    enable = mkEnableOption "Enable zen-browser module";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      inputs.zen-browser.packages."${system}".specific
    ];
  };
}
