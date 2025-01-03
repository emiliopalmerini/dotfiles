{ lib, config, pkgs, ... }:

{
  options = {
    bruno.enable = lib.mkEnableOption "enable bruno";
  };

    config = lib.mkIf config.bruno.enable {
    home.packages = [
      pkgs.bruno
    ];
    };
}
