{ lib, config, ... }:

with lib;
let
  cfg = config.ghostty;
in
{
  options = {
    ghostty.enable = mkEnableOption "Enable Ghostty configuration";
  };

  config = mkIf cfg.enable {
    home.file.".config/ghostty/config".text = ''
      font-family = "Hack Nerd Font Mono"
      font-feature = -calt -liga -dlig
      theme = tokyonight-storm
    '';
  };
}
