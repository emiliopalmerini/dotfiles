{ userConfig, ... }:
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

  # Core developer tools for server management
  go.enable = true;
  lazygit.enable = true;
  make.enable = true;
  neovim.enable = true;
  shell.enable = true;
  tmux.enable = true;
  claude.enable = true;
}
