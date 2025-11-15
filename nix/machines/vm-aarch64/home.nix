{ pkgs, inputs, userConfig, lib, ... }:

{
  imports = [
    ../../modules/home
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
  neovim.enableCSharp = false; # roslyn-nvim not available on aarch64-linux
  shell.enable = true;
  tmux.enable = true;
  mongodb.enable = true;
  nodejs.enable = true;
  dotnet.enable = true;

  # Desktop environment configuration
  hyprland.enable = true;

  # Development and productivity packages
  home.packages = [
    # Development tools
    pkgs.claude-code
    pkgs.lazygit
    pkgs.gnumake
    pkgs.gcc
    pkgs.protobuf
    pkgs.grpcurl

    # Basic utilities
    pkgs.ripgrep
    pkgs.fd
    pkgs.eza
    pkgs.bat
    pkgs.fzf
    pkgs.jq

    # Desktop applications
    pkgs.ghostty
    pkgs.obsidian

    # Work tools
    pkgs.postman
    pkgs.bruno
  ] ++ lib.optionals pkgs.stdenv.isLinux [ pkgs.xclip ];

  # Browser - zen-browser requires special setup
  programs.zen-browser = {
    enable = true;
  };

  # Let Home Manager manage itself
  programs.home-manager.enable = true;
}
