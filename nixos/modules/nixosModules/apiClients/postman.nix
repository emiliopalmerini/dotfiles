{ lib, config, pkgs, ... }:

{
  options = {
    postman.enable = lib.mkEnableOption "enable postman";
  };

  config = lib.mkIf config.postman.enable {
    environment.systemPackages = [
      pkgs.postman
    ];
  };
}
