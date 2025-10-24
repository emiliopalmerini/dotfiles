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
      type = types.enum [ "qemu" "virtualbox" ];
      default = "qemu";
      description = "VM backend to use (qemu or virtualbox)";
    };

    enableQemuGuestAgent = mkOption {
      type = types.bool;
      default = true;
      description = "Enable QEMU guest agent for better host-guest communication";
    };

    enableVirtualboxGuest = mkOption {
      type = types.bool;
      default = true;
      description = "Enable VirtualBox guest additions";
    };

    enableSharedFolders = mkOption {
      type = types.bool;
      default = false;
      description = "Enable shared folders support";
    };

    sharedFolders = mkOption {
      type = types.listOf (types.submodule {
        options = {
          name = mkOption {
            type = types.str;
            description = "Name of the shared folder";
          };
          hostPath = mkOption {
            type = types.str;
            description = "Path on the host system";
          };
          guestPath = mkOption {
            type = types.str;
            description = "Mount point in the guest system";
          };
        };
      });
      default = [];
      description = "Shared folders between host and guest";
    };
  };

  config = mkIf cfg.enable {
    # VM-specific system configuration
    virtualisation = {
      # Memory and disk configuration
      memorySize = lib.toInt (builtins.replaceStrings ["G" "M"] ["" ""] cfg.memorySize);
      diskSize = lib.toInt (builtins.replaceStrings ["G" "M"] ["" ""] cfg.diskSize) * 1024;

      # Graphics configuration
      graphics = !cfg.headless;

      # QEMU-specific configuration
      qemu = mkIf (cfg.backend == "qemu") {
        options = [
          "-enable-kvm"
          "-cpu host"
        ] ++ optional (!cfg.headless) "-vga virtio";

        # QEMU guest agent
        guestAgent.enable = cfg.enableQemuGuestAgent;
      };

      # VirtualBox-specific configuration
      virtualbox = mkIf (cfg.backend == "virtualbox") {
        guest = {
          enable = cfg.enableVirtualboxGuest;
          x11 = !cfg.headless;
        };
      };

      # Shared folders
      sharedDirectories = mkIf cfg.enableSharedFolders (
        builtins.listToAttrs (
          map (folder: {
            name = folder.name;
            value = {
              source = folder.hostPath;
              target = folder.guestPath;
            };
          }) cfg.sharedFolders
        )
      );
    };

    # VM-optimized services
    services = {
      # Enable SSH for remote access (especially important for headless VMs)
      openssh = {
        enable = mkDefault true;
        settings = {
          PasswordAuthentication = mkDefault true;
          PermitRootLogin = mkDefault "no";
        };
      };

      # QEMU guest agent service
      qemuGuest.enable = mkIf (cfg.backend == "qemu" && cfg.enableQemuGuestAgent) true;
    };

    # VM-optimized system settings
    boot = {
      # Faster boot for VMs
      loader.timeout = mkDefault 1;

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
      # Use simpler network backend for VMs
      useDHCP = mkDefault true;

      # Firewall rules (allow SSH by default for VMs)
      firewall = {
        enable = mkDefault true;
        allowedTCPPorts = mkDefault [ 22 ]; # SSH
      };
    };

    # Environment hints that this is a VM
    environment.etc."is-vm".text = "This is a NixOS VM";

    # Minimal system packages for VMs
    environment.systemPackages = with pkgs; mkDefault [
      vim
      git
      wget
      curl
    ];

    # Disable some unnecessary services in VMs
    services.udisks2.enable = mkDefault false;

    # Power management is usually not needed in VMs
    powerManagement.enable = mkDefault false;
  };
}
