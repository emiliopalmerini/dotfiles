# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/nixos
      inputs.home-manager.nixosModules.default
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "hera"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Rome";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "it_IT.UTF-8";
    LC_IDENTIFICATION = "it_IT.UTF-8";
    LC_MEASUREMENT = "it_IT.UTF-8";
    LC_MONETARY = "it_IT.UTF-8";
    LC_NAME = "it_IT.UTF-8";
    LC_NUMERIC = "it_IT.UTF-8";
    LC_PAPER = "it_IT.UTF-8";
    LC_TELEPHONE = "it_IT.UTF-8";
    LC_TIME = "it_IT.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "intl";
  };

  # Configure console keymap
  console.keyMap = "us-acentos";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.prometeo = {
    isNormalUser = true;
    description = "Prometeo";
    extraGroups = [ "networkmanager" "wheel" "plex" ];
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "prometeo" = import ./home.nix;
    };
    backupFileExtension = "bak";
  };

  environment.variables = {
    EDITOR = "nvim";
    TERM = "xterm-256color";
  };

  docker = {
    enable = true;
  };

  services.openssh.enable = true;
  services.plex = {
    enable = true;
    dataDir = "/var/lib/plex";
    openFirewall = true;
    user = "plex";
    group = "plex";
  };
  tailscale.enable = true;
  clamav.enable = true;
  programs.zsh.enable = true;
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ 6881 8080 ];
  networking.firewall.enable = false;

  logind = {
    lidSwitch = "ignore";
    extraConfig = ''
    HandlePowerKey=ignore
    '';
  };
  acpid = {
    enable = true;
    lidEventCommands =
      ''
    export PATH=$PATH:/run/current-system/sw/bin

    lid_state=$(cat /proc/acpi/button/lid/LID0/state | awk '{print $NF}')
    if [ $lid_state = "closed" ]; then
      # Set brightness to zero
      echo 0  > /sys/class/backlight/acpi_video0/brightness
    else
      # Reset the brightness
      echo 50  > /sys/class/backlight/acpi_video0/brightness
    fi
      '';

    powerEventCommands =
      ''
    systemctl suspend
      '';
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
