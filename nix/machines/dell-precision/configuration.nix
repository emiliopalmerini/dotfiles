# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ pkgs, inputs, userConfig, commonEnv, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
    inputs.home-manager.nixosModules.default
  ];

  boot = {
    # Bootloader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };
  networking.hostName = "dell-precision"; # Define your hostname.

  # Enable shared modules
  basic-system.enable = true;
  basic-system.enableBootloader = false; # Custom boot config above
  hyprland.enable = true;
  italian-locale.enable = true;
  # Note: using manual home-manager config due to zen-browser special import
  system = {
    autoUpgrade.enable = true;
    autoUpgrade.dates = "weekly";

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    stateVersion = "24.11";
  };
  # Override basic-system nix gc settings
  basic-system.nixGcDays = "daily";
  basic-system.nixGcKeepDays = "10d";

  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  mainUser = {
    enable = true;
    user = userConfig.username;
  };

  # Additional groups specific to dell-xps-15
  users.users.${userConfig.username}.extraGroups = [ "vboxusers" ];

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = [
    pkgs.networkmanager
    pkgs.sstp
    pkgs.ppp
    pkgs.mono
    pkgs.msbuild
    pkgs.docker-compose
    pkgs.lazydocker
  ];

  tailscale.enable = true;

  home-manager = {
    extraSpecialArgs = { inherit inputs userConfig; };
    users = {
      "${userConfig.username}" = import ./home.nix;
    };
    backupFileExtension = "bak";
  };

  virtualisation.docker = {
    enable = true;
  };
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      postgres = {
        image = "postgres:16";
        ports = [ "5432:5432" ];
        environment = {
          POSTGRES_PASSWORD = "postgres";
          POSTGRES_USER = "postgres";
          POSTGRES_DB = "postgres";
        };
        volumes = [
          "postgres-data:/var/lib/postgresql/data"
        ];
      };
    };
  };

  environment.variables = commonEnv;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  programs.zsh.enable = true;
  services.flatpak.enable = true;
  users.defaultUserShell = pkgs.zsh; # Did you read the comment?

  # Enable generic Docker module and it-tools container
  docker.enable = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = [
    # Add any additional libraries needed
    pkgs.stdenv.cc.cc
    pkgs.zlib
    pkgs.openssl
    pkgs.icu
  ];
}
