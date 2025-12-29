{ pkgs, inputs, userConfig, commonEnv, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
    inputs.home-manager.nixosModules.default
  ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  networking.hostName = "dell-precision";

  basic-system.enable = true;
  basic-system.enableBootloader = false;
  basic-system.nixGcDays = "daily";
  basic-system.nixGcKeepDays = "10d";
  gnome-desktop.enable = true;
  italian-locale.enable = true;
  input-method.enable = true;
  tailscale.enable = true;
  docker.enable = true;

  system = {
    autoUpgrade.enable = true;
    autoUpgrade.dates = "weekly";
    stateVersion = "24.11";
  };

  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;

  services.flatpak.enable = true;

  mainUser = {
    enable = true;
    user = userConfig.username;
  };
  users.users.${userConfig.username}.extraGroups = [ "vboxusers" ];
  users.defaultUserShell = pkgs.zsh;

  programs.firefox.enable = true;
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = [
    pkgs.stdenv.cc.cc
    pkgs.zlib
    pkgs.openssl
    pkgs.icu
  ];

  environment.systemPackages = [
    pkgs.networkmanager
    pkgs.sstp
    pkgs.ppp
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
