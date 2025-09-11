{ lib, config, ... }:

with lib;

{
  options.darwin.dock = {
    enable = mkEnableOption "Darwin dock configuration";

    autohide = mkOption {
      type = types.bool;
      default = true;
      description = "Automatically hide and show the dock";
    };

    persistentApps = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "List of applications to keep in the dock";
    };
  };

  config = mkIf config.darwin.dock.enable {
    system.defaults.dock = {
      autohide = config.darwin.dock.autohide;
      persistent-apps = config.darwin.dock.persistentApps;
    };
  };
}