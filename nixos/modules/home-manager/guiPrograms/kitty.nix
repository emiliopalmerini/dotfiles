{ lib, config, pkgs, ... }:

let
  cfg = config.kitty;
in
{
  options.kitty = {
    enable 
      = lib.mkEnableOption "enable kitty module";
  };

  config = lib.mkIf cfg.enable {
  	programs.kitty.enable = true;
  };
}
