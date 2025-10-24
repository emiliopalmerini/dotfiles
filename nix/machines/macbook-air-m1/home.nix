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

  # Core developer tools (complex modules with configs)
  go.enable = true;
  neovim.enable = true;
  shell.enable = true;
  tmux.enable = true;
  nodejs.enable = true;

  # macOS specific session path
  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  # Packages - both macOS specific and cross-platform
  home.packages = with pkgs; [
    # Development tools
    claude-code
    lazygit
    gnumake
    gcc
    lua

    # Desktop applications
    google-chrome
    obsidian
    todoist
    ghostty

    # macOS specific tools
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
