{ config, pkgs, lib, inputs, userConfig, commonEnv, ... }:

{
  imports = [
    ../modules/nixos
    inputs.home-manager.nixosModules.default
  ];

  # Enable VM module
  vm.enable = true;
  vm.headless = false;  # Enable GUI for development VMs
  vm.diskSize = "20G";
  vm.memorySize = "4G";

  # Enable basic system configuration
  basic-system.enable = true;

  # Define hostname (will be overridden by specific VM configs)
  networking.hostName = lib.mkDefault "nixos-vm";

  # Main user configuration
  mainUser = {
    enable = true;
    user = userConfig.username;
  };

  # Home Manager integration
  home-manager = {
    extraSpecialArgs = { inherit inputs userConfig; };
    users = {
      "${userConfig.username}" = import ./vm-home.nix;
    };
    backupFileExtension = "bak";
  };

  # VM-optimized settings
  security.sudo.wheelNeedsPassword = false;  # Convenience for VMs

  # Enable SSH for remote access
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = true;
  services.openssh.settings.PermitRootLogin = "no";

  # Disable firewall for easier VM access (NAT networking)
  networking.firewall.enable = false;

  # Virtualization and containerization
  virtualisation.docker.enable = true;
  users.users.${userConfig.username}.extraGroups = [ "docker" ];

  # Enable Tailscale for VPN access
  tailscale.enable = true;

  # Development and system tools
  environment.systemPackages = with pkgs; [
    # Core utilities
    vim
    git
    wget
    curl
    htop
    tree
    gnumake

    # Development tools
    gcc
    python3

    # Network utilities
    nettools
    dnsutils

    # Container tools
    docker-compose
    lazydocker

    # System monitoring
    iotop
    iftop

    # Clipboard support for Wayland
    wl-clipboard
  ];

  # Pass common environment variables
  environment.variables = commonEnv;

  # Enable zsh
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Allow unfree packages (needed for some development tools)
  nixpkgs.config.allowUnfree = true;

  # Enable Firefox
  programs.firefox.enable = true;

  # System state version
  system.stateVersion = "24.11";
}
