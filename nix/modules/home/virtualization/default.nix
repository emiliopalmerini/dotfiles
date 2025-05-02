{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.vm;
in
{
  options = {
    vm.enable 
      = mkEnableOption "enable vm";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
    quickemu
    qemu_kvm
    ];
  };
}
