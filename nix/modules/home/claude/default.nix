{ lib
, config
, pkgs
, ...
}:
with lib; let
  cfg = config.claude;
in
{
  options.claude = {
    enable = mkEnableOption "Enable claude module";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      claude-code
    ];
  };
}
