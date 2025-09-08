{ pkgs, userConfig, ... }:
{
  imports = [
    ./../../modules/home
  ];

  home.username = userConfig.username;
  home.homeDirectory = userConfig.homeDirectory;
  home.stateVersion = "24.11"; # Please read the comment before changing.
  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  home.packages = with pkgs; [
    mongosh
    raycast
    nodejs
    docker
    docker-compose
    lazydocker
    mas
    clamav
    hugo
    colima
    rectangle
  ];

  bruno.enable = true;
  discord.enable = false;
  gcc.enable = true;
  gimp.enable = true;
  git.enable = true;
  git.userEmail = userConfig.email;
  git.userName = "emiliopalmerini";
  go.enable = true;
  hugo.enable = false;
  lazygit.enable = true;
  lua.enable = true;
  neovim.enable = true;
  shell.enable = true;
  telegram.enable = true;
  tmux.enable = true;
  todoist.enable = true;
}

