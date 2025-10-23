{ inputs, userConfig, commonEnv, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
    inputs.home-manager.nixosModules.default
  ];

  networking.hostName = "athena"; # Define your hostname.
  networking.nameservers = [ "8.8.8.8" "8.8.4.4" ];

  # Enable shared modules
  basic-system.enable = true;
  gnome-desktop.enable = true;
  home-manager-integration.enable = true;
  home-manager-integration.homeConfigPath = ./home.nix;

  services.openssh.enable = true;

  mainUser = {
    enable = true;
    user = userConfig.username;
  };

  environment.variables = commonEnv;

  # Enable generic Docker module and it-tools container
  docker.enable = true;


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
