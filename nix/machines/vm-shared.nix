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

  # Basic development tools
  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    curl
    htop
    tree
  ];

  # Pass common environment variables
  environment.variables = commonEnv;

  # Enable zsh
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # System state version
  system.stateVersion = "24.11";
}
