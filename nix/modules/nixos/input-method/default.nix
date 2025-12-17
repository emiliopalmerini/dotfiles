{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.input-method;
in
{
  options.input-method = {
    enable = mkEnableOption "Enable input method (IBus) for dead keys and compose key support on Wayland";
    
    engines = mkOption {
      type = types.listOf types.package;
      default = with pkgs.ibus-engines; [ libpinyin ];
      description = "IBus engines to enable";
    };
  };

  config = mkIf cfg.enable {
    i18n.inputMethod.enable = true;
    i18n.inputMethod.type = "ibus";
    i18n.inputMethod.ibus.engines = cfg.engines;
  };
}
