{ config, pkgs, inputs, userConfig, ... }:

{
  imports = [
    ../modules/home
  ];

  # Home Manager state version
  home.stateVersion = "24.11";

  # User info
  home.username = userConfig.username;
  home.homeDirectory = userConfig.homeDirectory;

  # Enable essential development modules
  git.enable = true;
  shell.enable = true;
  tmux.enable = true;
  neovim.enable = true;

  # Basic packages for VMs
  home.packages = with pkgs; [
    # Basic utilities
    ripgrep
    fd
    eza
    bat
    fzf

    # Development tools
    gcc
    gnumake
  ];

  # Let Home Manager manage itself
  programs.home-manager.enable = true;
}
