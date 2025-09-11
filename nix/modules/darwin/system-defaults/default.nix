{ lib, config, ... }:

with lib;

{
  options.darwin.systemDefaults = {
    enable = mkEnableOption "Darwin system defaults configuration";

    finder = {
      preferredViewStyle = mkOption {
        type = types.enum [ "icnv" "clmv" "Flwv" "Nlsv" ];
        default = "clmv";
        description = "Finder preferred view style (icon, column, flow, list)";
      };

      removeOldTrashItems = mkOption {
        type = types.bool;
        default = true;
        description = "Remove items from trash after 30 days";
      };

      showPathbar = mkOption {
        type = types.bool;
        default = true;
        description = "Show path bar in Finder";
      };
    };

    loginwindow = {
      guestEnabled = mkOption {
        type = types.bool;
        default = false;
        description = "Enable guest user account";
      };
    };

    globalDomain = {
      force24HourTime = mkOption {
        type = types.bool;
        default = true;
        description = "Use 24-hour time format";
      };

      interfaceStyle = mkOption {
        type = types.enum [ "Light" "Dark" ];
        default = "Dark";
        description = "Interface appearance style";
      };

      naturalScrollDirection = mkOption {
        type = types.bool;
        default = true;
        description = "Natural scroll direction (reversed for mice)";
      };

      keyRepeat = mkOption {
        type = types.int;
        default = 2;
        description = "Key repeat rate (lower is faster)";
      };
    };
  };

  config = mkIf config.darwin.systemDefaults.enable {
    system.defaults = {
      finder = {
        FXPreferredViewStyle = config.darwin.systemDefaults.finder.preferredViewStyle;
        FXRemoveOldTrashItems = config.darwin.systemDefaults.finder.removeOldTrashItems;
        ShowPathbar = config.darwin.systemDefaults.finder.showPathbar;
      };

      loginwindow.GuestEnabled = config.darwin.systemDefaults.loginwindow.guestEnabled;

      NSGlobalDomain = {
        AppleICUForce24HourTime = config.darwin.systemDefaults.globalDomain.force24HourTime;
        AppleInterfaceStyle = config.darwin.systemDefaults.globalDomain.interfaceStyle;
        "com.apple.swipescrolldirection" = config.darwin.systemDefaults.globalDomain.naturalScrollDirection;
        KeyRepeat = config.darwin.systemDefaults.globalDomain.keyRepeat;
      };
    };
  };
}