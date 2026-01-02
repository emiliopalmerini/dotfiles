{ pkgs, inputs, userConfig, ... }:
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

  # Core developer tools
  git.enable = true;
  git.userEmail = userConfig.email;
  go.enable = true;
  neovim.enable = true;
  shell.enable = true;
  tmux.enable = true;
  nodejs.enable = true;
  yazi.enable = true;
  mongodb.enable = true;

  # Application configurations
  ghostty.enable = true;
  lazygit.enable = true;
  ripgrep.enable = true;
  claude.enable = true;

  # Environment management
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # SSH configuration
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      addKeysToAgent = "yes";
      identitiesOnly = true;
    };
  };

  # macOS specific session path
  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  home.packages = with pkgs; [
    # Development tools
    gnumake
    gcc
    zig
    lua
    hugo
    inputs.grimoire.packages.${pkgs.system}.default

    # Version control and collaboration
    graphite-cli

    # Docker
    docker
    docker-compose
    colima
    lazydocker

    # Media tools
    ffmpeg
    python313Packages.markitdown

    # macOS utilities
    mas
  ];
}
