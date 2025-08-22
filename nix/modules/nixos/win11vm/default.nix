{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.win11vm;
in {
  options.win11vm = {
    enable = mkEnableOption "Enable Windows 11 VM integration options";

    installerIsoPath = mkOption {
      type = types.path;
      default = "/var/lib/libvirt/isos/windows11.iso";
      description = "Absolute path to the Windows 11 installer ISO.";
    };

    autounattendIsoPath = mkOption {
      type = types.path;
      default = "/var/lib/libvirt/isos/autounattend.iso";
      description = "Absolute path to the generated Autounattend ISO.";
    };

    memoryMB = mkOption {
      type = types.int;
      default = 8192;
      description = "Amount of RAM (MB) for the VM (TF_VAR_memory_mb).";
    };

    vcpu = mkOption {
      type = types.int;
      default = 4;
      description = "Number of virtual CPUs for the VM (TF_VAR_vcpu).";
    };

    diskGB = mkOption {
      type = types.int;
      default = 80;
      description = "Disk size in GB for the VM (TF_VAR_disk_size).";
    };

    terraformSource = mkOption {
      type = types.path;
      # Default to the repo's hephaestus terraform folder; can be overridden
      default = ../../hosts/hephaestus/win11-vm/terraform;
      description = "Path to the Terraform source directory for the Windows 11 VM.";
    };
  };

  config = mkIf cfg.enable {
    # Export Terraform variables so `terraform apply` picks them up automatically
    environment.variables = {
      TF_VAR_win_iso_path = toString cfg.installerIsoPath;
      TF_VAR_autounattend_iso_path = toString cfg.autounattendIsoPath;
      TF_VAR_memory_mb = toString cfg.memoryMB;
      TF_VAR_vcpu = toString cfg.vcpu;
      TF_VAR_disk_size = toString cfg.diskGB;
    };

    # Helper script to apply the Terraform plan from a writable working directory
    environment.systemPackages = with pkgs; [
      (pkgs.writeShellScriptBin "win11-vm-apply" ''
        set -euo pipefail
        SRC='${cfg.terraformSource}'
        WORKDIR='/var/lib/win11-vm/terraform'
        INSTALLER='${cfg.installerIsoPath}'
        AUTOISO='${cfg.autounattendIsoPath}'

        if [ ! -f "$INSTALLER" ]; then
          echo "ERROR: Installer ISO not found at $INSTALLER" >&2
          exit 1
        fi
        if [ ! -f "$AUTOISO" ]; then
          echo "ERROR: Autounattend ISO not found at $AUTOISO" >&2
          exit 1
        fi

        echo "Preparing Terraform workdir at $WORKDIR"
        mkdir -p "$WORKDIR"
        # Sync source to workdir (store is read-only)
        rm -rf "$WORKDIR"/*
        cp -R "$SRC"/* "$WORKDIR"/

        cd "$WORKDIR"
        echo "Checking libvirt connectivity..."
        if ! ${pkgs.libvirt}/bin/virsh -c qemu:///system list >/dev/null 2>&1; then
          echo "WARNING: libvirt not reachable. Ensure libvirtd is running and user is in libvirtd/kvm groups." >&2
        fi

        echo "Running: terraform init"
        ${pkgs.terraform}/bin/terraform init -input=false
        echo "Running: terraform apply -auto-approve"
        ${pkgs.terraform}/bin/terraform apply -auto-approve
      '')
    ];

    # Ensure working directory exists
    systemd.tmpfiles.rules = [
      "d /var/lib/win11-vm/terraform 0755 root root -"
    ];
  };
}
