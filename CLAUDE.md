# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Architecture

This is a personal dotfiles repository with multi-platform support (NixOS, macOS, Windows). The core is a Nix flake-based system with modular Home Manager configurations.

### Directory Structure

- `nix/` - Main Nix configuration directory
  - `flake.nix` - Entry point defining all system configurations
  - `machines/` - Per-machine configurations (physical hosts and VMs)
    - `dell-xps-15/` - Work laptop (NixOS)
    - `thinkpad-home-server/` - Home server (NixOS)
    - `macbook-air-m1/` - Personal MacBook (macOS)
    - `vm-aarch64.nix` - ARM64 VM for macOS (VMware/Parallels/QEMU)
    - `wsl.nix` - Windows WSL configuration
    - `vm-shared.nix` - Common VM configuration
    - `vm-home.nix` - Shared Home Manager config for VMs
    - `hardware/` - Hardware configurations for machines and VMs
  - `modules/` - Reusable configuration modules
    - `home/` - Home Manager modules (tools, apps, development environments)
    - `nixos/` - NixOS system modules (including `vm/` for VM-specific settings)
    - `darwin/` - macOS-specific modules
  - `lib/` - Utility functions for configuration generation
- `powershell/` - Windows PowerShell configuration and setup
- `.claude/agents/` - Contains nixos-config-expert agent for Nix-related tasks

### Module System

Home Manager uses a hybrid approach:

**Modules (8 total)** - For tools with complex configuration:
- **Development tools**: `git` (aliases, hooks), `neovim` (LSPs, plugins), `shell` (zsh with oh-my-posh), `tmux` (keybindings)
- **Languages with environment setup**: `nodejs` (npm config, PATH), `dotnet` (multiple SDKs, DOTNET_ROOT)
- **Convenient bundles**: `go` (7 related tools), `mongodb` (3 related tools)

Modules are enabled per-machine with `<module>.enable = true;`.

**Direct packages** - For simple applications without custom config:
- Installed directly in `home.packages = [ pkgs.package-name ]`
- Examples: chrome, obsidian, slack, lazygit, gcc, etc.
- More explicit and easier to manage than wrapper modules

## Common Commands

### NixOS Systems
- Build and switch: `sudo nixos-rebuild switch --flake nix#<machine-name>`
- Test configuration: `sudo nixos-rebuild test --flake nix#<machine-name>`

### macOS Systems
- Build and switch: `darwin-rebuild switch --flake nix#<machine-name>`

### VMs and WSL
- **vm-aarch64**: For running NixOS on macOS (VMware Fusion, Parallels, or QEMU)
  - Build VM: `nix build nix#nixosConfigurations.vm-aarch64.config.system.build.vm`
  - Run VM: `./result/bin/run-vm-aarch64-vm`
  - Includes shared filesystem at `/host` for easy file sharing
- **wsl**: For running NixOS on Windows via WSL
  - Build: `sudo nixos-rebuild switch --flake nix#wsl`
  - Uses WSL-specific configuration with automount at `/mnt`

### Flake Management
- Update inputs: `nix flake update --flake nix`
- Check flake: `nix flake check --flake nix`

### Garbage Collection
- Clean old generations: `nix-collect-garbage --delete-old`
- Clean generations older than 30 days: `nix-collect-garbage --delete-older-than 30d`

### Windows PowerShell Setup
- Full setup: `.\setup.ps1` (run from `powershell/` directory)
- Setup without fonts: `.\setup.ps1 -SkipFontInstall`
- Force overwrite: `.\setup.ps1 -Force`

## Development Workflow

### Adding New Machines
**Physical machines:**
1. Create `nix/machines/<machine-name>/configuration.nix` and `home.nix`
2. Copy hardware configuration for NixOS machines
3. Add machine name to appropriate list in `nix/flake.nix` (nixosMachines or darwinMachines)

**VMs (Mitchell Hashimoto style):**
1. Create `nix/machines/vm-<name>.nix` that imports `vm-shared.nix`
2. Create `nix/machines/hardware/vm-<name>.nix` with hardware config
3. Add VM name to `nixosMachines` list in `nix/flake.nix`
4. Add user config to `nix/lib/users.nix`
5. Customize VM-specific settings (hostname, network interface, backend)

### Adding New Home Manager Modules
1. Create module directory in `nix/modules/home/<module-name>/`
2. Add module to imports in `nix/modules/home/default.nix`
3. Follow existing module patterns with `enable` option

### Machine Configurations
- **NixOS machines**: dell-xps-15, thinkpad-home-server (x86_64-linux)
- **macOS machines**: macbook-air-m1 (aarch64-darwin)
- **VMs and WSL**: vm-aarch64, wsl

Physical machines have their own directory with `configuration.nix` (system config) and `home.nix` (user environment config).

VMs follow Mitchell Hashimoto's pattern: single `.nix` files in `machines/` directory that import `vm-shared.nix` for common VM configuration.

## Key Files to Understand

- `nix/lib/default.nix` - Core functions for generating system configurations
- `nix/lib/users.nix` - User-specific configurations per machine
- `nix/modules/home/` - Individual Home Manager modules for tools and applications
- `nix/machines/<machine-name>/home.nix` - Per-machine Home Manager module selection