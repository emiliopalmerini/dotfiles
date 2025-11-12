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

  # Simple packages - installed directly
  home.packages = with pkgs; [
    # Development tools
    claude-code
    lazygit
    gnumake
    gcc

    # Desktop applications
    google-chrome
    obsidian
    todoist
    telegram-desktop
    ghostty
    gnomeExtensions.clipboard-indicator # Clipboard history manager

    # Work tools
    libreoffice
    slack
    postman
    bruno
    openfortivpn
    jetbrains.rider
  ] ++ lib.optionals stdenv.isLinux [ xclip ];

  # Browser - zen-browser requires special setup
  programs.zen-browser = {
    enable = true;
  };
}
