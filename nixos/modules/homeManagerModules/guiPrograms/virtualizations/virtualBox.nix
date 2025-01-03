{ lib, config, pkgs, ... }:

let
  cfg = config.virtualBox;
in
{
  options.virtualBox = {
    enable 
      = lib.mkEnableOption "enable virtualBox module";

    user = lib.mkOption {
      default = "main user";
      description = ''
        username
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.virtualbox.host.enable = true;
    users.extraGroups.vboxusers.members = [ cfg.user ];
  };
}
