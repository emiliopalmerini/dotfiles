{ config, lib, ... }:

with lib;

let
  cfg = config.ghostty;
in
{
  options.ghostty = {
    enable = mkEnableOption "Ghostty terminal emulator";
  };

  config = mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      settings = {
        font-family = "Hack Nerd Font Mono";
        font-feature = [ "-calt" "-liga" "-dlig" ];
        theme = "tokyonight-storm";
      };
    };
  };
}
