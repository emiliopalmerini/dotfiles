# Dotfiles & Nix Flakes

A reproducible Nix/NixOS/Home Manager setup with per-host configurations and modular Home Manager packages (Neovim, shell, tools, apps).

- Flake lives in `nix/flake.nix`
- Hosts are under `nix/hosts/*`
- Home Manager modules live in `nix/modules/home/*`
- NixOS modules live in `nix/modules/nixos/*`

## Prerequisites
- Nix with flakes enabled
- For NixOS machines: installer ISO or an existing system
- For macOS: nix-darwin installed

## Layout
- `nix/flake.nix`: Entrypoint. Exposes `nixosConfigurations.*` and `darwinConfigurations.*`
- `nix/hosts/<host>/configuration.nix`: Host configuration (NixOS or macOS)
- `nix/hosts/<host>/home.nix`: Home Manager for that host/user
- `nix/modules/home/*`: Home Manager modules (e.g., `neovim`, `git`, `tmux`, ...)
- `nix/modules/nixos/*`: Reusable NixOS modules

## Bootstrap (NixOS)
1) Generate hardware config on the target machine:
- If installing fresh, the installer generates `/etc/nixos/hardware-configuration.nix`.
- Copy it into the repo (example for host `athena`):
  `sudo cp /etc/nixos/hardware-configuration.nix nix/hosts/athena/hardware-configuration.nix`
2) Build and switch:
- `sudo nixos-rebuild switch --flake nix#athena`

Update the host name to match an existing output in `nix/flake.nix` (`dell-xps-15`, `thinkpad-home-server`, `dell-precision`, `vm-aarch64`), or add a new one.

## Bootstrap (macOS)
1) Install nix-darwin (follow upstream docs).
2) Switch using the flake output (example host `macbook-air-m1`):
- `darwin-rebuild switch --flake nix#macbook-air-m1`

## Home Manager
Home Manager is integrated into each host's config. Toggle modules per-host in `nix/machines/<host>/home.nix` by setting `<module>.enable = true;`.

Example (macOS host `macbook-air-m1`):
- `neovim.enable = true;`
- `git.enable = true;`
- `tmux.enable = true;`

The module registry is in `nix/modules/home/default.nix`.

## Neovim Module
Enable with `neovim.enable = true;` in `home.nix`. It provides:
- Plugins (Treesitter, LSP, DAP, Telescope, Copilot, etc.)
- LSP servers and formatters via Nix packages (no Mason)
- DAP configured for Go, C#, Python, and JS/TS
- OS-aware clipboard and debug tooling

Details and keymaps: see `nix/modules/home/neovim/README.md`.

## Key HM Modules
- Git: `nix/modules/home/git/README.md`
- Tmux: `nix/modules/home/tmux/README.md`
- Shell (Zsh): `nix/modules/home/shell/README.md`

## Updating inputs
- From the repo root: `nix flake update --flake nix`
- Commit the updated `nix/flake.lock`

## Common commands
- NixOS switch: `sudo nixos-rebuild switch --flake nix#<host>`
- macOS switch: `darwin-rebuild switch --flake nix#<host>`
- Home-only (when using HM directly): `home-manager switch --flake nix#<host>`
- Clean old generations: `nix-collect-garbage --delete-old`
- Clean generations older than 30 days: `nix-collect-garbage --delete-older-than 30d`

## Adding a new host
1) Create `nix/machines/<new-host>/configuration.nix` and `home.nix` (copy from an existing host).
2) Copy the machine's `hardware-configuration.nix` to the same directory (NixOS only).
3) Add the host name to the appropriate list in `nix/flake.nix` (`nixosMachines` or `darwinMachines`).
4) Switch with the appropriate command.
