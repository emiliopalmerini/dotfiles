
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
  gnome-desktop.enable = true;
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

  services = {
    # X server and keyboard
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "intl";
      };
    };

    # Moved out of services.xserver.* per renames in 24.11
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;


    # Enable CUPS to print documents.
    printing.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };
  };

  environment.gnome.excludePackages = (with pkgs; [
    atomix # puzzle game
    cheese # webcam tool
    epiphany # web browser
    evince # document viewer
    geary # email reader
    gedit # text editor
    gnome-characters
    gnome-music
    gnome-photos
    gnome-terminal
    gnome-tour
    hitori # sudoku game
    iagno # go game
    tali # poker game
    totem # video player
  ]);
  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

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
  environment.systemPackages = with pkgs; [
    networkmanager
    sstp
    ppp
    mono
    msbuild
    docker-compose
    lazydocker
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
  virtualisation.oci-containers.backend = "docker";

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
}
