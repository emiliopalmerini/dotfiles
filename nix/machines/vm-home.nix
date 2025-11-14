{ config, pkgs, inputs, userConfig, lib, ... }:

{
  imports = [
    ../modules/home
    inputs.zen-browser.homeModules.twilight
  ];

  # Home Manager state version
  home.stateVersion = "24.11";

  # User info
  home.username = userConfig.username;
  home.homeDirectory = userConfig.homeDirectory;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Git configuration
  git.enable = true;
  git.userEmail = userConfig.email;
  git.userName = "emiliopalmerini";

  # Core developer tools (complex modules with configs)
  go.enable = true;
  neovim.enable = true;
  shell.enable = true;
  tmux.enable = true;
  mongodb.enable = true;
  nodejs.enable = true;
  dotnet.enable = true;

  # Desktop environment configuration
  hyprland.enable = true;

  # Development and productivity packages
  home.packages = with pkgs; [
    # Development tools
    claude-code
    lazygit
    gnumake
    gcc
    protobuf
    grpcurl

    # Basic utilities
    ripgrep
    fd
    eza
    bat
    fzf
    jq

    # Desktop applications
    ghostty
    obsidian

    # Work tools
    postman
    bruno
  ] ++ lib.optionals stdenv.isLinux [ xclip ];

  # Browser - zen-browser requires special setup
  programs.zen-browser = {
    enable = true;
  };

  # Let Home Manager manage itself
  programs.home-manager.enable = true;
}
