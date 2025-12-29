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

  # Core developer tools (complex modules with configs)
  git.enable = true;
  git.userEmail = userConfig.email;
  go.enable = true;
  neovim.enable = true;
  shell.enable = true;
  tmux.enable = true;
  nodejs.enable = true;
  yazi.enable = true;

  # Application configurations
  ghostty.enable = true;
  lazygit.enable = true;
  ripgrep.enable = true;

  # macOS specific session path
  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  home.packages = [
    # Development tools
    pkgs.gnumake
    pkgs.gcc
    pkgs.zig
    pkgs.lua
    pkgs.hugo

    # Version control and collaboration
    pkgs.graphite-cli

    # Database tools
    pkgs.mongosh
    pkgs.mongodb-tools

    # Docker management
    pkgs.lazydocker

    # Media tools
    pkgs.ffmpeg
    pkgs.python313Packages.markitdown

    # macOS utilities
    pkgs.mas
    pkgs.clamav

    # IDEs and editors
    pkgs.code-cursor
  ];
}
