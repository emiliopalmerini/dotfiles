# Windows 11 VM on Hephaestus (libvirt + Terraform)

This folder provisions a Windows 11 virtual machine using:
- NixOS: installs libvirt/qemu, swtpm, terraform, and tooling
- Terraform: defines the VM (UEFI, vTPM, disk, networking)
- PowerShell: a `setup.ps1` run via Autounattend on first boot

## Prerequisites
- On Hephaestus, libvirt is enabled and user is in `libvirtd`/`kvm` groups
- Place the Windows 11 ISO at `/var/lib/libvirt/isos/windows11.iso`
- Build an Autounattend ISO that contains `Autounattend.xml` and `setup.ps1` at the root
  - Reproducible ISO via Nix flake:
    - Optionally create `vpn.json` (ignored by git) from `vpn-example.json` with SSTP details (name, server, username, password)
    - Build: `nix build nix#win11AutounattendIso`
    - Copy/symlink result to libvirt ISOs: `install -m0644 result /var/lib/libvirt/isos/autounattend.iso`

## Quick start
- Export variables or edit `terraform.tfvars`:
  - `win_iso_path = "/var/lib/libvirt/isos/windows11.iso"`
  - `autounattend_iso_path = "/var/lib/libvirt/isos/autounattend.iso"`
- Then:
```
cd nix/hosts/hephaestus/win11-vm/terraform
terraform init
terraform apply
```

The VM boots from the Windows ISO and reads `Autounattend.xml` from the second CD-ROM, running `scripts/setup.ps1` at first logon.

## Notes
- UEFI and vTPM are enabled to satisfy Windows 11 requirements
- The VM uses the default libvirt network
- Disk size, CPU, RAM are customizable via variables

## Installed developer tools
The first-boot PowerShell `setup.ps1` installs:
- Visual Studio 2022 Community with workloads: Managed Desktop and ASP.NET/Web
- .NET SDKs: 5.0, 6.0, 7.0, 8.0 (side-by-side)
- MongoDB Compass
- Neovim
- Utilities: Git, 7-Zip, vswhere

## Routing host traffic via the VM
The Windows setup enables IP forwarding and configures a NAT (New-NetNat) on the VM. On the NixOS host you can toggle routing:
- Enable: `sudo win11-vm-route-enable` (sets default route to the VM’s IP)
- Disable: `sudo win11-vm-route-disable` (restores previous route)

Notes:
- Ensure the VM is running; qemu-guest-agent helps discover the VM IP.
- The VM performs NAT for the libvirt subnet, forwarding to its default gateway (libvirt).
- If you also connect an SSTP VPN inside Windows (the setup script prepares defaults, and will auto-create/connect if `vpn.json` is provided), the VM’s default route will point to the VPN and the host traffic (when enabled) will traverse it.
