{ lib, config, pkgs, ... }:

let
  cfg = config.firefox;
in
{
  options.firefox = {
    enable 
      = lib.mkEnableOption "enable firefox module";
  };

    config = lib.mkIf cfg.enable {
      enable = true;
      package = pkgs.firefox.override {
        cfg = {
          # Gnome shell native connector
          enableGnomeExtensions = true;
        };
      };

      profiles = {
        default = {
          id = 0;
          name = "default";
          isDefault = true;
          settings = {
            "middlemouse.paste" = false;
          };
        };
      };
    };
}
