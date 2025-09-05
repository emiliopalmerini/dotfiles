{ lib, config, pkgs, ... }:

let
  cfg = config.ghostty;
in
{
  options.ghostty = {
    enable = lib.mkEnableOption "Enable ghostty module";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ ghostty ];

    xdg.configFile."ghostty/config".text = ''
      theme = tokyonight-storm
      shell-integration = zsh
    '';
  };
}
