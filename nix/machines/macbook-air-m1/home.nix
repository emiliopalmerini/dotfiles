{ pkgs, userConfig, ... }:
{
  imports = [
    ./../../modules/home
  ];

  # Base Home Manager configuration
  home.username = userConfig.username;
  home.homeDirectory = userConfig.homeDirectory;
  home.stateVersion = "24.11";

  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;

  # Git configuration
  git.enable = true;
  git.userEmail = userConfig.email;
  git.userName = "emiliopalmerini";

  # Core developer tools
  go.enable = true;
  lazygit.enable = true;
  make.enable = true;
  neovim.enable = true;
  shell.enable = true;
  tmux.enable = true;
  claude.enable = true;
  nodejs.enable = true;
  lua.enable = true;

  # Desktop applications
  chrome.enable = true;
  gcc.enable = true;
  obsidian.enable = true;
  todoist.enable = true;
  ghostty.enable = true;

  # Disabled - not available or not needed on macOS
  telegram.enable = false; # Not available on macOS via Nix
  vlc.enable = false; # Not needed
  bruno.enable = false; # Not available on macOS via Nix
  discord.enable = false;
  gimp.enable = false; # Not available on macOS via Nix

  # macOS specific session path
  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  # macOS specific packages and tools
  home.packages = with pkgs; [
    mongosh
    mongodb-tools
    raycast
    docker
    docker-compose
    lazydocker
    mas
    clamav
    hugo
    colima
  ];
}
