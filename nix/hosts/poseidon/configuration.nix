{ config, pkgs, inputs, ... }:

let
  userName = "prometeo";
in
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  networking.hostName = "poseidon"; # Define your hostname.

  systemDefault.enable = true;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  mainUser = {
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
  };

  docker.enable = true;
  ghostty.enable = false;
  plex.enable = true;
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
