{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.vm;
in {
  options = {
    vm.enable =
      mkEnableOption "enable vm";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      qemu_kvm # QEMU con supporto KVM
      quickemu
      # crea qemu-system-x86_64-uefi in $HOME/.nix-profile/bin
      (writeShellScriptBin "qemu-system-x86_64-uefi" ''
        qemu-system-x86_64 \
          -bios ${pkgs.OVMF.fd}/FV/OVMF.fd \
          "$@"
      '')
    ];
  };
}
