data "libvirt_network" "default" {
  name = "default"
}

resource "libvirt_volume" "win11_disk" {
  name   = "${var.vm_name}.qcow2"
  pool   = "default"
  format = "qcow2"
  size   = var.disk_size * 1024 * 1024 * 1024
}

resource "libvirt_domain" "win11" {
  name   = var.vm_name
  memory = var.memory_mb
  vcpu   = var.vcpu

  # Use UEFI firmware; on NixOS libvirt exposes OVMF at /run/libvirt/nix-ovmf/
  firmware = "/run/libvirt/nix-ovmf/OVMF_CODE.fd"

  network_interface {
    network_id = data.libvirt_network.default.id
  }

  disk {
    volume_id = libvirt_volume.win11_disk.id
  }

  # Windows installer ISO
  cdrom {
    file = var.win_iso_path
  }

  # Autounattend + setup.ps1 ISO
  cdrom {
    file = var.autounattend_iso_path
  }

  # TPM for Windows 11
  tpm {
    model        = "tpm-crb"
    backend_type = "emulator"
  }

  graphics {
    type        = "spice"
    listen_type = "none"
    autoport    = true
  }

  video {
    type = "qxl"
  }
}

