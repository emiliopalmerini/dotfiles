{ lib, config, ... }:

with lib;
let
  cfg = config.arc;
in
{
  options.arc = {
    enable = mkEnableOption "Enable arc module";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      arc-browser
    ];
  };
}
