{ lib, config, ... }:

with lib;
let
  cfg = config.italian-locale;
in
{
  options.italian-locale = {
    enable = mkEnableOption "Enable Italian locale and timezone configuration";
    
    consoleKeyMap = mkOption {
      type = types.str;
      default = "us-acentos";
      description = "Console keymap for Italian accented characters";
    };
  };

  config = mkIf cfg.enable {
    # Timezone
    time.timeZone = "Europe/Rome";

    # Locale settings
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "it_IT.UTF-8";
      LC_IDENTIFICATION = "it_IT.UTF-8";
      LC_MEASUREMENT = "it_IT.UTF-8";
      LC_MONETARY = "it_IT.UTF-8";
      LC_NAME = "it_IT.UTF-8";
      LC_NUMERIC = "it_IT.UTF-8";
      LC_PAPER = "it_IT.UTF-8";
      LC_TELEPHONE = "it_IT.UTF-8";
      LC_TIME = "it_IT.UTF-8";
    };

    # Console keymap for accented characters
    console.keyMap = cfg.consoleKeyMap;
  };
}