# NixOS VM Setup on macOS with VMware Fusion

This guide explains how to set up a NixOS virtual machine on macOS using VMware Fusion, with Hyprland desktop environment and a complete development setup.

## Overview

The VM configuration provides:
- **NixOS** with Hyprland window manager (matching dell-precision setup)
- **Full development environment**: Go, Node.js, .NET, MongoDB, Neovim, and more
- **VMware integration**: Shared folders at `/host`, clipboard sharing, display auto-resize
- **x86_64 emulation**: Run x86_64 binaries on ARM64 via QEMU
- **Docker and Tailscale**: Containerization and VPN support
- **Mitchell Hashimoto-style workflow**: Easy configuration management via Makefile

## Prerequisites

1. **VMware Fusion** (free for personal use)
   - Download from: https://www.vmware.com/products/fusion.html
   - Install and accept license

2. **NixOS ISO**
   - Download from: https://nixos.org/download.html#nixos-iso
   - Choose: **Minimal ISO image (aarch64)** for Apple Silicon Macs
   - Latest stable or unstable release

## Quick Start

### 1. Create the VM

Run the command to see detailed instructions:
```bash
make vm/create
```

Or follow these steps:

#### a. Create VM in VMware Fusion
1. Open VMware Fusion
2. File → New → Create Custom Virtual Machine
3. Choose operating system:
   - **Other Linux 5.x or later kernel 64-bit ARM**
4. Select firmware type:
   - **UEFI**
5. Create a new virtual disk:
   - **150GB** (or more if you have space)
6. Finish creation, then customize settings:

#### b. Recommended VM Settings
- **Processors & Memory**:
  - CPUs: 4-8 cores (at least half your Mac's cores)
  - RAM: 8-16GB (at least half your Mac's RAM)
- **Hard Disk**: 150GB+ SATA
- **Network Adapter**: Shared with my Mac
- **Display**:
  - Accelerate 3D Graphics: ✓
  - Full Resolution for Retina Display: ✓
  - Graphics Memory: Maximum
- **Remove these devices**:
  - Sound Card
  - Camera
  - Printer

### 2. Install NixOS

#### a. Boot from ISO
1. In VM settings, add the NixOS ISO to CD/DVD
2. Start the VM
3. Boot from the ISO

#### b. Partition the Disk
```bash
# Become root
sudo -i

# Identify your disk (usually /dev/sda or /dev/vda)
lsblk

# Partition the disk (adjust device name if needed)
parted /dev/sda -- mklabel gpt
parted /dev/sda -- mkpart primary 512MB -8GB
parted /dev/sda -- mkpart primary linux-swap -8GB 100%
parted /dev/sda -- mkpart ESP fat32 1MB 512MB
parted /dev/sda -- set 3 esp on

# Format partitions
mkfs.ext4 -L nixos /dev/sda1
mkswap -L swap /dev/sda2
mkfs.fat -F 32 -n boot /dev/sda3

# Mount filesystems
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
swapon /dev/sda2
```

#### c. Generate Configuration
```bash
# Generate hardware config
nixos-generate-config --root /mnt

# Edit configuration
nano /mnt/etc/nixos/configuration.nix
```

Add these essential lines to enable SSH access:
```nix
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = true;
  services.openssh.settings.PermitRootLogin = "yes";
  users.users.root.initialPassword = "root";
```

#### d. Install and Reboot
```bash
# Install NixOS
nixos-install

# Reboot (remove ISO from CD/DVD first)
reboot
```

### 3. Bootstrap Your Configuration

After the VM reboots:

#### a. Find the VM IP Address
```bash
# In the VM, run:
ip addr show ens160
```

The IP will typically be in the `192.168.58.x` range.

#### b. Bootstrap from Your Mac
```bash
# From your Mac, in the dotfiles directory:
make vm/bootstrap NIXADDR=<VM-IP-ADDRESS>

# Example:
make vm/bootstrap NIXADDR=192.168.58.128
```

This will:
1. Copy your configuration to the VM
2. Build and activate the full NixOS configuration with Hyprland
3. Reboot the VM

#### c. First Login
After the final reboot:
1. You'll see SDDM login screen
2. Login with username: `emilio`, password: (set during bootstrap)
3. Select "Hyprland" as session type
4. Enjoy your development environment!

## Daily Workflow

### Making Configuration Changes

1. Edit files in `nix/` directory on your Mac
2. Deploy changes to VM:
   ```bash
   make vm/switch NIXADDR=<VM-IP>
   ```

### Testing Changes
```bash
# Test without switching (reverts on reboot)
make vm/test NIXADDR=<VM-IP>
```

### SSH Access
```bash
# Quick SSH into VM
make vm/ssh NIXADDR=<VM-IP>

# Or directly
ssh emilio@<VM-IP>
```

### Updating the System
```bash
# Update flake inputs and rebuild
make vm/update NIXADDR=<VM-IP>
```

## Features

### Hyprland Desktop
The VM runs Hyprland with the same configuration as dell-precision:
- **6 workspaces**: Super+1 through Super+6
- **Waybar**: Status bar with system info
- **Wofi**: Application launcher (Super+Space)
- **Swaylock**: Screen locker (Super+L)
- **Dunst**: Notification daemon

### Development Tools
Pre-installed and configured:
- **Languages**: Go, Node.js, .NET, Python
- **Editors**: Neovim (fully configured), VS Code
- **Databases**: MongoDB tools
- **Containers**: Docker with docker-compose
- **Tools**: Git, Tmux, Lazygit, Claude Code
- **Browsers**: Firefox, Zen Browser

### VMware Integration
- **Shared folders**: macOS home accessible at `/host`
- **Clipboard**: Copy/paste between macOS and VM
- **Display**: Auto-resize when window changes
- **Drag & drop**: Files between macOS and VM

### Network
- **Tailscale**: VPN for accessing other machines
- **SSH**: Enabled by default
- **Firewall**: Disabled for development convenience

## Tips and Tricks

### Accessing macOS Files
```bash
# macOS home directory is mounted at /host
cd /host
ls /host/Downloads
```

### Performance Tuning
If the VM feels slow:
1. Increase CPU cores in VM settings
2. Increase RAM allocation
3. Enable "Use full resolution for Retina display"
4. Close unnecessary apps on macOS

### Snapshots
Take VM snapshots before major changes:
1. Virtual Machine → Snapshots → Take Snapshot
2. Name it descriptively
3. Restore if something breaks

### Remote Development
With Tailscale enabled, you can:
```bash
# From any machine on your Tailscale network
ssh emilio@vm-dev
```

## Troubleshooting

### Can't Find VM IP
```bash
# In the VM terminal:
ip addr show ens160

# Or check VMware's DHCP leases on macOS:
cat /Library/Preferences/VMware\ Fusion/vmnet8/dhcpd.conf
```

### SSH Connection Refused
```bash
# Check if SSH is running in VM:
sudo systemctl status sshd

# Restart if needed:
sudo systemctl restart sshd
```

### Display Issues
1. Ensure "Accelerate 3D Graphics" is enabled in VM settings
2. Try restarting the VM
3. Check VMware Tools are installed: `systemctl status vmware-vmblock-fuse`

### Shared Folders Not Working
```bash
# Check if vmhgfs-fuse is running:
mount | grep host

# Manually mount if needed:
sudo mount -t fuse.vmhgfs-fuse .host:/ /host -o allow_other
```

### Build Failures
```bash
# Check the flake configuration:
make vm/check

# Try a clean rebuild:
cd nix && nix-collect-garbage -d
make vm/switch NIXADDR=<VM-IP>
```

## Customization

### Change Hostname
Edit `nix/machines/vm-aarch64.nix`:
```nix
networking.hostName = "your-hostname";
```

### Add More Tools
Edit `nix/machines/vm-home.nix`:
```nix
home.packages = with pkgs; [
  # Add your packages here
  your-package
];
```

### Different Desktop Environment
In `nix/machines/vm-aarch64.nix`, replace:
```nix
hyprland.enable = true;
```
with:
```nix
gnome-desktop.enable = true;
```

## Resources

- **NixOS Manual**: https://nixos.org/manual/nixos/stable/
- **Home Manager Manual**: https://nix-community.github.io/home-manager/
- **Hyprland Wiki**: https://wiki.hyprland.org/
- **VMware Fusion**: https://docs.vmware.com/en/VMware-Fusion/
- **Mitchell Hashimoto's Config**: https://github.com/mitchellh/nixos-config

## Credits

VM setup inspired by [Mitchell Hashimoto's nixos-config](https://github.com/mitchellh/nixos-config).
