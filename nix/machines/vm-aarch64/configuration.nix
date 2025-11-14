{ config, pkgs, lib, inputs, userConfig, commonEnv, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
    inputs.home-manager.nixosModules.default
  ];

  # Enable VM module
  vm.enable = true;
  vm.headless = false;  # Enable GUI for development VMs
  vm.diskSize = "20G";
  vm.memorySize = "4G";

  # Enable basic system configuration
  basic-system.enable = true;

  # Hostname
  networking.hostName = "vm-dev";

  # Setup qemu so we can run x86_64 binaries
  boot.binfmt.emulatedSystems = ["x86_64-linux"];

  # Network configuration for VMware Fusion
  networking.useDHCP = lib.mkDefault true;

  # Interface is this on M1 with VMware Fusion
  networking.interfaces.ens160.useDHCP = true;

  # DNS servers (fixes "Could not resolve host" issues)
  networking.nameservers = [ "8.8.8.8" "8.8.4.4" "1.1.1.1" ];

  # Disable firewall for easier VM access (NAT networking)
  networking.firewall.enable = false;

  # Lots of stuff that uses aarch64 that claims doesn't work, but actually works.
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;

  # Boot configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 3;

  # Time zone and locale
  time.timeZone = "Europe/Rome";
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable Hyprland desktop environment
  hyprland.enable = true;

  # Italian locale for regional settings
  italian-locale.enable = true;

  # VMware guest tools
  virtualisation.vmware.guest.enable = true;

  # Share our host filesystem at /host
  fileSystems."/host" = {
    fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
    device = ".host:/";
    options = [
      "umask=22"
      "uid=1000"
      "gid=1000"
      "allow_other"
      "auto_unmount"
      "defaults"
    ];
  };

  # Main user configuration
  mainUser = {
    enable = true;
    user = userConfig.username;
  };

  # VM-optimized settings
  security.sudo.wheelNeedsPassword = false;  # Convenience for VMs

  # Enable SSH for remote access
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = true;
  services.openssh.settings.PermitRootLogin = "no";

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

  # Enable Firefox
  programs.firefox.enable = true;

  # Home Manager integration
  home-manager = {
    extraSpecialArgs = { inherit inputs userConfig; };
    users = {
      "${userConfig.username}" = import ./home.nix;
    };
    backupFileExtension = "bak";
  };

  # System state version
  system.stateVersion = "24.11";
}
