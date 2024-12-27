{ lib, config, pkgs, ... }:

{
  options = {
    bruno.enable = lib.mkEnableOption "enable bruno";
  };

    config = lib.mkIf config.bruno.enable {
    environment.systemPackages = [
      pkgs.bruno
    ];
    };
}
