# VM Support Implementation Tasks

This document outlines the planned tasks for adding VM support to the NixOS configuration, following the Mitchell Hashimoto-style approach.

## Overview

The goal is to support both physical machines and VMs in the `machines/` directory structure, allowing for easy configuration and deployment of virtual machines alongside physical hosts.

## Architecture Changes

### 1. Machine Type Classification

Create a distinction between physical machines and VMs while keeping them in the same `machines/` directory:

```
machines/
├── dell-xps-15/           # Physical machine
├── macbook-air-m1/        # Physical machine
├── thinkpad-home-server/  # Physical machine
└── vms/
    ├── dev-vm/            # Development VM
    └── test-vm/           # Testing VM
```

### 2. VM Configuration Pattern

Each VM should have:
- `configuration.nix` - NixOS system configuration
- `home.nix` - Home Manager configuration (optional)
- VM-specific settings (disk size, memory, networking)

### 3. Flake Updates

Update `nix/flake.nix` to:
- Add `vmMachines` list alongside `nixosMachines` and `darwinMachines`
- Create VM-specific configuration generation function
- Support VM-specific options (headless, disk size, memory allocation)

### 4. Library Functions

Add to `nix/lib/default.nix`:
- `mkVmSystem` function for generating VM configurations
- VM-specific defaults (smaller disk, less memory, headless by default)
- Helper for generating VM images (QEMU, VirtualBox, etc.)

## Task Breakdown

### Phase 1: Directory Structure
- [ ] Create `machines/vms/` directory
- [ ] Create template VM configuration
- [ ] Document VM naming convention

### Phase 2: Flake Configuration
- [ ] Add `vmMachines` list to flake.nix
- [ ] Update flake to support VM configurations
- [ ] Add VM-specific outputs (VM images, ISOs)

### Phase 3: Library Functions
- [ ] Create `mkVmSystem` function in lib/default.nix
- [ ] Add VM-specific module for common VM settings
- [ ] Support different VM backends (QEMU, VirtualBox, VMware)

### Phase 4: User Configuration
- [ ] Update lib/users.nix to support VM users
- [ ] Define default VM user configuration
- [ ] Support shared users across physical and VM machines

### Phase 5: VM Modules
- [ ] Create VM-specific NixOS modules in `modules/nixos/vm/`
- [ ] Add QEMU guest agent configuration
- [ ] Add VirtualBox guest additions configuration
- [ ] Add shared folder support

### Phase 6: Build Scripts
- [ ] Add helper scripts for building VM images
- [ ] Add scripts for running VMs locally
- [ ] Add scripts for deploying VMs to remote hosts

### Phase 7: Documentation
- [ ] Update CLAUDE.md with VM support documentation
- [ ] Add examples for creating new VMs
- [ ] Document VM-specific commands and workflows

## VM Configuration Examples

### Example 1: Development VM

```nix
# machines/vms/dev-vm/configuration.nix
{ pkgs, userConfig, ... }:
{
  imports = [
    ../../../modules/nixos
    ../../../modules/nixos/vm
  ];

  # VM-specific settings
  vm = {
    enable = true;
    diskSize = "20G";
    memorySize = "4G";
    headless = false;
  };

  networking.hostName = "dev-vm";

  # Enable basic system configuration
  basic-system.enable = true;

  # Minimal development tools
  environment.systemPackages = with pkgs; [
    git
    vim
  ];

  mainUser = {
    enable = true;
    user = userConfig.username;
  };

  system.stateVersion = "24.11";
}
```

### Example 2: Headless Test VM

```nix
# machines/vms/test-vm/configuration.nix
{ pkgs, userConfig, ... }:
{
  imports = [
    ../../../modules/nixos
    ../../../modules/nixos/vm
  ];

  # VM-specific settings
  vm = {
    enable = true;
    diskSize = "10G";
    memorySize = "2G";
    headless = true;
  };

  networking.hostName = "test-vm";

  # Minimal system for testing
  basic-system.enable = true;

  # SSH access only
  services.openssh.enable = true;

  mainUser = {
    enable = true;
    user = userConfig.username;
  };

  system.stateVersion = "24.11";
}
```

## Build Commands

Once implemented, VMs can be built with:

```bash
# Build VM image
nix build .#nixosConfigurations.dev-vm.config.system.build.vm

# Run VM locally
./result/bin/run-dev-vm-vm

# Build VM image for specific backend
nix build .#nixosConfigurations.dev-vm.config.system.build.virtualBoxOVA
nix build .#nixosConfigurations.dev-vm.config.system.build.qcow2
```

## Benefits

1. **Unified Configuration**: Physical and virtual machines managed in the same way
2. **Easy Testing**: Test configuration changes in VMs before applying to physical machines
3. **Development Environments**: Quickly spin up isolated development environments
4. **Reproducibility**: VM configurations are fully declarative and reproducible
5. **Mitchell Hashimoto Style**: Follows proven patterns from Hashicorp founder's dotfiles

## Notes

- VMs inherit most configuration from the main NixOS modules
- VM-specific settings (disk size, memory) are configured per-VM
- Home Manager can be used in VMs just like physical machines
- VMs can be deployed to remote hosts using NixOps or similar tools
- Consider using `nixos-rebuild build-vm` for quick local testing

## References

- [NixOS VM Testing](https://nixos.org/manual/nixos/stable/#sec-nixos-tests)
- [Mitchell Hashimoto's Dotfiles](https://github.com/mitchellh/nixos-config)
- [Building NixOS VMs](https://nixos.wiki/wiki/NixOS:nixos-rebuild_build-vm)
