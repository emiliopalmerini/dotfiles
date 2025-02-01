{ lib, config, pkgs, ... }:

{
  options = {
    rectangle.enable = 
      lib.mkEnableOption "enable rectangle";
  };

    config = lib.mkIf config.rectangle.enable {
    home.packages = with pkgs; [
      rectangle
    ];
    };
}
