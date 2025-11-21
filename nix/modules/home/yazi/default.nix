{ lib
, config
, pkgs
, ...
}:
with lib; let
  cfg = config.yazi;
in
{
  options = {
    yazi.enable = mkEnableOption "Enable yazi";
  };
  config = mkIf cfg.enable {
    home.packages = [
      pkgs.yazi
      # pkgs.yaziPlugins.git
      # pkgs.yaziPlugins.ouch
      # pkgs.yaziPlugins.diff
    ];

    # xdg.configFile."yazi/keymap.toml".source = ./keymap.toml;
  };
}
