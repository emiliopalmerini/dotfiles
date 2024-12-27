{ lib, config, pkgs, ... }:

let
  cfg = config.gnomeBoxes;
in
{
  options.gnomeBoxes = {
    enable 
      = lib.mkEnableOption "enable gnomeBoxes module";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.libvirtd.enable = true;
    environment.systemPackages = [
      pkgs.gnome-boxes
    ];
  };
}
