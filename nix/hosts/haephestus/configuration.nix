{ config, pkgs, inputs, ... }:

let
  userName = "emil_io";
in
  {
  imports =
    [
      ./hardware-configuration.nix
    ];

  networking.hostName = "haephestus"; # Define your hostname.
  hyprland.enable = true;

  systemDefault.enable = true;

  services.printing.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  mainUser ={
    enable = true;
    user = "${userName}";
  };

  home-manager = {
    extraSpecialArgs =  { inherit inputs; };
    users = {
      "${userName}" = import ./home.nix;
    };
    backupFileExtension = "bak";
  };

  environment.variables = {
    EDITOR = "nvim";
    TERM = "xterm-256color";
    NIXOS_OZONE_WL = "1";
  };

  ghostty.enable = true;
  docker.enable = true;

  services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
