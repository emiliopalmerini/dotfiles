{ inputs, pkgs, userConfig, ... }: {
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

  # Core developer tools
  go.enable = true;
  lazygit.enable = true;
  make.enable = true;
  neovim.enable = true;
  shell.enable = true;
  tmux.enable = true;
  claude.enable = true;
  mongodb.enable = true;
  nodejs.enable = true;

  # Desktop applications
  chrome.enable = true;
  gcc.enable = true;
  obsidian.enable = true;
  todoist.enable = true;
  telegram.enable = true;
  ghostty.enable = true;

  # Work tools
  office.enable = true;
  slack.enable = true;
  dotnet.enable = true;
  postman.enable = true;
  bruno.enable = true;

  # Browser - zen-browser requires special setup
  programs.zen-browser = {
    enable = true;
  };
}
