{ pkgs, inputs, userConfig, commonEnv, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
    inputs.home-manager.nixosModules.default
  ];

  boot = {
    kernelParams = [ "kvm.enable_virt_at_load=0" ];
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    initrd.luks.devices."luks-68c92b43-cf28-46bf-9a0a-96a2290dcdac".device = "/dev/disk/by-uuid/68c92b43-cf28-46bf-9a0a-96a2290dcdac";
  };

  networking.hostName = "dell-xps-15";

  basic-system.enable = true;
  basic-system.enableBootloader = false;
  basic-system.nixGcDays = "daily";
  basic-system.nixGcKeepDays = "10d";
  gnome-desktop.enable = true;
  italian-locale.enable = true;
  tailscale.enable = true;
  docker.enable = true;

  system = {
    autoUpgrade.enable = true;
    autoUpgrade.dates = "weekly";
    stateVersion = "24.11";
  };

  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
  virtualisation.oci-containers.backend = "docker";

  services = {
    xserver = {
      enable = true;
      xkb = { layout = "us"; variant = "intl"; };
    };
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    printing.enable = true;
    pulseaudio.enable = false;
    flatpak.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  security.rtkit.enable = true;

  environment.gnome.excludePackages = [
    pkgs.atomix
    pkgs.cheese
    pkgs.epiphany
    pkgs.evince
    pkgs.geary
    pkgs.gedit
    pkgs.gnome-characters
    pkgs.gnome-music
    pkgs.gnome-photos
    pkgs.gnome-terminal
    pkgs.gnome-tour
    pkgs.hitori
    pkgs.iagno
    pkgs.tali
    pkgs.totem
  ];

  mainUser = {
    enable = true;
    user = userConfig.username;
  };
  users.users.${userConfig.username}.extraGroups = [ "vboxusers" ];
  users.defaultUserShell = pkgs.zsh;

  programs.firefox.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  environment.systemPackages = [
    pkgs.networkmanager
    pkgs.sstp
    pkgs.ppp
    pkgs.quickemu
    pkgs.vagrant
    pkgs.mono
    pkgs.msbuild
  ];
  environment.variables = commonEnv;

  home-manager = {
    extraSpecialArgs = { inherit inputs userConfig; };
    users."${userConfig.username}" = import ./home.nix;
    backupFileExtension = "bak";
  };
}
