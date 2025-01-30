{ config, pkgs, inputs, ... }:

{
  imports = [
  	./../../modules/homeManagerModules
  ];

  home.stateVersion = "24.11"; # Please read the comment before changing.

  neovim.enable = true;

  git.enable = true;
  git.userName = "emiliopalmerini";
  git.userEmail = "emiliopalmerini@proton.me";

  tmux.enable = true;
  customShell.enable = true;

  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    gcc
    go
    lua
    todoist
    discord
    obsidian
    lazygit
  ];

  programs.home-manager.enable = true;
}
