{ lib, config, pkgs, ... }:
{
  options.plex.enable =
    lib.mkEnableOption "Enable plex module";

  config = lib.mkIf config.plex.enable {
    services.plex = {
      enable = true;
      openFirewall = true;
      user = "prometeo";
      group = "users";
    };
  };
}

