{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.vm;
in
{
  options.vm = {
    enable = mkEnableOption "Enable VM-specific configuration";

    diskSize = mkOption {
      type = types.str;
      default = "20G";
      description = "Virtual disk size for the VM";
    };

    memorySize = mkOption {
      type = types.str;
      default = "2G";
      description = "Memory size for the VM";
    };

    headless = mkOption {
      type = types.bool;
      default = true;
      description = "Run VM in headless mode (no GUI)";
    };

    backend = mkOption {
      type = types.enum [ "qemu" "vmware" ];
      default = "vmware";
      description = "VM backend to use (qemu or vmware)";
    };

    enableQemuGuestAgent = mkOption {
      type = types.bool;
      default = true;
      description = "Enable QEMU guest agent for better host-guest communication";
    };
  };

  config = mkIf cfg.enable {
    # VM-specific system configuration

    # QEMU-specific configuration
    services.qemuGuest.enable = mkIf (cfg.backend == "qemu" && cfg.enableQemuGuestAgent) true;

    # VM-optimized services
    services = {
      # Enable SSH for remote access (especially important for VMs)
      openssh = {
        enable = mkDefault true;
        settings = {
          PasswordAuthentication = mkDefault true;
          PermitRootLogin = mkDefault "no";
        };
      };

      # SPICE/QEMU guest agent for QEMU VMs
      spice-vdagentd.enable = mkIf (cfg.backend == "qemu" && !cfg.headless) true;
    };

    # VM-optimized system settings
    boot = {
      # Faster boot for VMs
      loader.timeout = mkDefault 3;

      # Kernel modules for VM guests
      kernelModules = mkIf (cfg.backend == "qemu") [
        "virtio_balloon"
        "virtio_blk"
        "virtio_net"
        "virtio_pci"
        "virtio_rng"
      ];
    };

    # Networking optimizations for VMs
    networking = {
      # Use DHCP by default for VMs
      useDHCP = mkDefault true;

      # Firewall rules (disabled by default for easier development)
      firewall = {
        enable = mkDefault false;
      };
    };

    # Environment hints that this is a VM
    environment.etc."is-vm".text = "This is a NixOS VM";

    # Minimal system packages for VMs
    environment.systemPackages = mkDefault [
      pkgs.vim
      pkgs.git
      pkgs.wget
      pkgs.curl
    ];

    # Disable some unnecessary services in VMs
    services.udisks2.enable = mkDefault false;

    # Power management is usually not needed in VMs
    powerManagement.enable = mkDefault false;

    # Enable automatic login for development VMs (convenience)
    # This should be overridden for production use
    # services.getty.autologinUser = mkDefault config.mainUser.user;
  };
}
