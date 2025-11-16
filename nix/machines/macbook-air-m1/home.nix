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

  home.file.".config/ghostty/config".text = ''
    font-family = "Hack Nerd Font Mono"
    font-feature = -calt -liga -dlig
    theme = tokyonight-storm
  '';

  # Packages - both macOS specific and cross-platform
  home.packages = [
    # Development tools
    pkgs.claude-code
    pkgs.lazygit
    pkgs.gnumake
    pkgs.gcc
    pkgs.lua
    pkgs.python313Packages.markitdown
    pkgs.ffmpeg

    # Desktop applications
    pkgs.obsidian

    # macOS specific tools
    pkgs.mongosh
    pkgs.mongodb-tools
    pkgs.raycast
    pkgs.docker
    pkgs.docker-compose
    pkgs.lazydocker
    pkgs.mas
    pkgs.clamav
    pkgs.hugo
    pkgs.colima
  ];
}
