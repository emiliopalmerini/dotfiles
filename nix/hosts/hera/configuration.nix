{ pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
    inputs.home-manager.nixosModules.default
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "hera";
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;

  time.timeZone = "Europe/Rome";

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

  services.xserver.xkb = {
    layout = "us";
    variant = "intl";
  };
  console.keyMap = "us-acentos";

  users.users.prometeo = {
    isNormalUser = true;
    description = "Prometeo";
    extraGroups = [ "networkmanager" "wheel" "plex" "docker" ];
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
  };

  nixpkgs.config.allowUnfree = true;

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users.prometeo = import ./home.nix;
    backupFileExtension = "bak";
  };

  environment.variables = {
    EDITOR = "nvim";
    TERM = "xterm-256color";
  };

  # Docker
  virtualisation.docker.enable = true;

  services.openssh.enable = true;

  # Plex
  services.plex = {
    enable = true;
    dataDir = "/var/lib/plex";
    openFirewall = true;
    user = "plex";
    group = "plex";
  };

  environment.systemPackages = with pkgs; [ nodejs ];
  # Tailscale
  services.tailscale.enable = true;

  # ClamAV
  services.clamav = {
    daemon.enable = true;
    updater.enable = true;
  };

  programs.zsh.enable = true;

  # logind
  services.logind = {
    lidSwitch = "ignore";
    extraConfig = ''
      HandlePowerKey=ignore
    '';
  };

  # ACPI daemon
  services.acpid = {
    enable = true;
    lidEventCommands = ''
      export PATH=$PATH:/run/current-system/sw/bin
      lid_state=$(awk '{print $NF}' /proc/acpi/button/lid/LID0/state)
      if [ "$lid_state" = "closed" ]; then
        echo 0  > /sys/class/backlight/acpi_video0/brightness
      else
        echo 50 > /sys/class/backlight/acpi_video0/brightness
      fi
    '';
    powerEventCommands = ''
      systemctl suspend
    '';
  };

  system.stateVersion = "24.11";
}

