# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Architecture

This is a personal dotfiles repository with multi-platform support (NixOS, macOS, Windows). The core is a Nix flake-based system with modular Home Manager configurations.

### Directory Structure

- `nix/` - Main Nix configuration directory
  - `flake.nix` - Entry point defining all system configurations
  - `hosts/` - Per-host configurations (athena, hera, hephaestus, eris)
  - `modules/` - Reusable configuration modules
    - `home/` - Home Manager modules (tools, apps, development environments)
    - `nixos/` - NixOS system modules
    - `darwin/` - macOS-specific modules
  - `lib/` - Utility functions for configuration generation
- `powershell/` - Windows PowerShell configuration and setup
- `.claude/agents/` - Contains nixos-config-expert agent for Nix-related tasks

### Module System

Home Manager modules are organized by category in `nix/modules/home/`:
- **Profiles**: `base`, `developer`, `desktop`, `work`
- **Development**: `git`, `neovim`, `vscode`, `shell`, `tmux`
- **Languages**: `go`, `dotnet`, `nodejs`, `php`, `lua`
- **Tools**: Terminal apps, GUI applications, databases

Each module can be enabled per-host in the host's `home.nix` file with `<module>.enable = true;`.

## Common Commands

### NixOS Systems
- Build and switch: `sudo nixos-rebuild switch --flake nix#<hostname>`
- Test configuration: `sudo nixos-rebuild test --flake nix#<hostname>`

### macOS Systems  
- Build and switch: `darwin-rebuild switch --flake nix#<hostname>`

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

### Adding New Hosts
1. Create `nix/hosts/<hostname>/configuration.nix` and `home.nix`
2. Copy hardware configuration for NixOS hosts
3. Add hostname to appropriate list in `nix/flake.nix` (nixosHosts or darwinHosts)

### Adding New Home Manager Modules
1. Create module directory in `nix/modules/home/<module-name>/`
2. Add module to imports in `nix/modules/home/default.nix`
3. Follow existing module patterns with `enable` option

### Host Configurations
- **NixOS hosts**: athena, hera, hephaestus (x86_64-linux)
- **macOS hosts**: eris (aarch64-darwin)

Each host has its own `configuration.nix` (system config) and `home.nix` (user environment config).

## Key Files to Understand

- `nix/lib/default.nix` - Core functions for generating system configurations
- `nix/lib/users.nix` - User-specific configurations per host
- `nix/modules/home/profiles/` - Bundled configurations for different use cases
- `nix/hosts/<hostname>/home.nix` - Per-host Home Manager module selection