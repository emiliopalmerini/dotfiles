{ pkgs, inputs, userConfig, ... }: {
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
  home.packages = [
    # Development tools
    pkgs.claude-code
    pkgs.lazygit
    pkgs.gnumake
    pkgs.gcc
    pkgs.protobuf # Protocol Buffers compiler (includes protoc)
    pkgs.grpcurl # gRPC CLI tool for testing endpoints

    # Desktop applications
    pkgs.google-chrome
    pkgs.obsidian
    pkgs.todoist
    pkgs.telegram-desktop
    pkgs.ghostty
    pkgs.gnomeExtensions.clipboard-indicator # Clipboard history manager
    pkgs.vlc

    # Work tools
    pkgs.libreoffice
    pkgs.postman
    pkgs.bruno
    pkgs.openfortivpn
    pkgs.jetbrains.rider
    pkgs.dbeaver-bin
    pkgs.amp-cli
    pkgs.lsof

    pkgs.xclip
  ];

  # Browser - zen-browser requires special setup
  programs.zen-browser = {
    enable = true;
  };
}
