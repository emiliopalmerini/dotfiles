# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
pkgs,
inputs,
...
}: let
  userName = "emilio";
in {
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
    inputs.home-manager.nixosModules.default
  ];
  boot = {
    # Bootloader.
    kernelParams = ["kvm.enable_virt_at_load=0"];
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    initrd.luks.devices."luks-68c92b43-cf28-46bf-9a0a-96a2290dcdac".device = "/dev/disk/by-uuid/68c92b43-cf28-46bf-9a0a-96a2290dcdac";
  };
  networking.hostName = "hephaestus"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.


  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
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
  nix = {
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 10d";
    };

    settings.auto-optimise-store = true;
    settings.experimental-features = ["nix-command" "flakes"];
  };

  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;

  # Libvirt/QEMU for Windows 11 VM provisioning via Terraform
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      ovmf.enable = true;   # UEFI firmware needed by Windows 11
      swtpm.enable = true;  # vTPM emulator for Windows 11
    };
  };
  programs.virt-manager.enable = true;

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
  services = {
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      xkb = {
        layout = "us";
        variant = "intl";
      };
    };


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
  users.users.${userName} = {
    isNormalUser = true;
    description = "${userName}";
    extraGroups = ["networkmanager" "wheel" "docker" "vboxusers" "libvirtd" "kvm"];
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
  };

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
    quickemu
    vagrant
    mono
    msbuild
    docker-compose
    lazydocker
    # VM + IaC tooling
    terraform
    qemu
    libvirt
    swtpm
    virt-manager
    genisoimage
  ];

  environment.etc."ppp/peers/vpn_nsa".text = ''
  pty "sstp-client --log-level 3 --cert-warn sstp://vpn.azienda.it"
  name adminpalmerini
  remotename sstp
  ipparam sstp
  usepeerdns
  refuse-chap
  refuse-mschap
  require-mschap-v2
  noauth
  defaultroute
  replacedefaultroute
  persist
  '';

  environment.etc."ppp/peers/vpn_nsa".mode = "0600";

  environment.etc."ppp/chap-secrets".text = ''
  "adminpalmerini@grupponsa.it" * "tebror-foCxeq-xopfy2" *
  '';

  environment.etc."ppp/chap-secrets".mode = "0600";

    nixpkgs.config.permittedInsecurePackages = [
      "dotnet-sdk-6.0.428"
      "dotnet-runtime-6.0.36"
    ];

    tailscale.enable = true;

    home-manager = {
      extraSpecialArgs = {inherit inputs;};
      users = {
        "${userName}" = import ./home.nix;
      };
      backupFileExtension = "bak";
    };

  virtualisation.docker = {
    enable = true;
  };
  virtualisation.oci-containers.backend = "docker";

  environment.variables = {
    EDITOR = "nvim";
    TERM = "xterm-256color";
  };

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

  # Paths for ISOs used by Terraform/libvirt
  systemd.tmpfiles.rules = [
    "d /var/lib/libvirt/isos 0755 root root -"
    "d /var/lib/libvirt/images 0755 root root -"
  ];

  # Symlink/copy the reproducible Autounattend ISO built via Nix during activation
  system.activationScripts.win11AutounattendIso = let
    autounattendIso = import ./win11-vm { inherit pkgs; };
  in {
    text = ''
      src=${autounattendIso}
      dst=/var/lib/libvirt/isos/autounattend.iso
      echo "Installing Autounattend ISO to $dst"
      install -m0644 -D "$src" "$dst"
    '';
  };

  # Export Terraform variables for Win11 VM (paths can be changed via module options)
  win11vm = {
    enable = true;
    installerIsoPath = "/var/lib/libvirt/isos/windows11.iso";
    autounattendIsoPath = "/var/lib/libvirt/isos/autounattend.iso";
    memoryMB = 12288;
    vcpu = 6;
    diskGB = 120;
  };
}
