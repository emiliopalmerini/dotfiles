{inputs, pkgs, userConfig, commonEnv, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
    inputs.home-manager.nixosModules.default
  ];

  networking.hostName = "athena"; # Define your hostname.
  networking.nameservers = ["8.8.8.8" "8.8.4.4"];

  services = {
    # X server and keyboard
    xserver = {
      enable = true;
      xkb.layout = "us";
      xkb.options = ""; # Aggiungi questa riga per il supporto delle lettere accentate
    };

    # Moved out of services.xserver.* per renames in 24.11
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;


    printing.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    openssh.enable = true;
  };

  mainUser = {
    enable = true;
    user = userConfig.username;
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs userConfig;};
    users = {
      "${userConfig.username}" = import ./home.nix;
    };
    backupFileExtension = "bak";
  };

  environment.variables = commonEnv;

  # Enable generic Docker module and it-tools container
  docker.enable = true;

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
