{ lib, config, ... }:

with lib;

{
  options.darwin.homebrew = {
    enable = mkEnableOption "Darwin homebrew configuration";

    brews = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "List of homebrew formulas to install";
    };

    casks = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "List of homebrew casks to install";
    };

    cleanup = mkOption {
      type = types.enum [ "none" "uninstall" "zap" ];
      default = "zap";
      description = "Cleanup strategy for homebrew packages";
    };
  };

  config = mkIf config.darwin.homebrew.enable {
    homebrew = {
      enable = true;
      brews = config.darwin.homebrew.brews;
      casks = config.darwin.homebrew.casks;
      onActivation.cleanup = config.darwin.homebrew.cleanup;
    };
  };
}