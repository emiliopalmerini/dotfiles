{ lib, config, pkgs, inputs, ... }:

with lib;
let
  cfg = config.hyprland;
in
  {
  options.hyprland = {
    enable = mkEnableOption "Enable hyprland module";
    user = mkOption {
      type = types.str;
      default = "emil_io";
      description = "The main user of the system";
    };
  };

  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };

    security.pam.services.hyprlock = {};
  };
}
