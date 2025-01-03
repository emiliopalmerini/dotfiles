{ lib, config, pkgs, inputs, ... }:

let
  cfg = config.ghostty;
in
{
  options.ghostty = {
    enable = lib.mkEnableOption "Enable ghostty module";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      inputs.unstablePkgs.ghostty
    ];
  };
}
