{ inputs, pkgs, userConfig, lib, ... }: {
  imports = [
    ./../../modules/home
    inputs.zen-browser.homeModules.twilight
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
  mongodb.enable = true;
  nodejs.enable = true;
  dotnet.enable = true;

  # Desktop environment configuration
  gnome-workspaces.enable = true;

  # CLI tools configuration
  claude.enable = true;

  # Simple packages - installed directly
  home.packages = [
    # Development tools
    pkgs.claude-code
    pkgs.lazygit
    pkgs.gnumake
    pkgs.gcc

    # Desktop applications
    pkgs.google-chrome
    pkgs.obsidian
    pkgs.todoist
    pkgs.telegram-desktop
    pkgs.ghostty
    pkgs.gnomeExtensions.clipboard-indicator # Clipboard history manager

    # Work tools
    pkgs.libreoffice
    pkgs.slack
    pkgs.postman
    pkgs.bruno
  ] ++ lib.optionals pkgs.stdenv.isLinux [ pkgs.xclip ];

  # Browser - zen-browser requires special setup
  programs.zen-browser = {
    enable = true;
  };
}
