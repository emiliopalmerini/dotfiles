{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware/vm-aarch64.nix
    ./vm-shared.nix
  ];

  # Hostname
  networking.hostName = "vm-dev";

  # Setup qemu so we can run x86_64 binaries
  boot.binfmt.emulatedSystems = ["x86_64-linux"];

  # Interface is this on M1 with VMware Fusion
  networking.interfaces.ens160.useDHCP = true;

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
}
