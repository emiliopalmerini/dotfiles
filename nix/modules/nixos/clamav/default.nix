{ lib, config, pkgs, ... }:

with lib;

let
  mkContOpt = name:
    mkEnableOption ("Enable clamav");

in {
  options.clamav.enable =
    mkEnableOption "Enable clamav";

  config = mkIf config.clamav.enable {
    environment.systemPackages = [
      pkgs.clamav
    ];
    services.clamav.daemon.enable = true;

    services.clamav.updater.enable = true;
  };
}

