{ pkgs, userConfig, ... }:

{
  imports = [
    ../modules/nixos
  ];

  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    defaultUser = userConfig.username;
    startMenuLaunchers = true;
  };

  # Enable basic system configuration
  basic-system.enable = true;
  basic-system.enableBootloader = false;  # WSL doesn't use bootloader
  basic-system.enableNetworkManager = false;  # WSL handles networking

  # Main user configuration
  mainUser = {
    enable = true;
    user = userConfig.username;
  };

  system.stateVersion = "24.11";
}
