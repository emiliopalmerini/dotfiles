{ config, pkgs, inputs, ... }:

{
  imports = [
  	./../../modules/homeManagerModules
  ];
  home.username = "emilio";
  home.homeDirectory = "/home/emilio";

  home.stateVersion = "24.11"; # Please read the comment before changing.

  firefox.enable = true;
  neovim.enable = true;
  kitty.enable = true;

  git.enable = true;
  git.userName = "emiliopalmerini";
  git.userEmail = "emiliopalmerini@codiceplastico.com";

  tmux.enable = true;
  zsh.enable = true;

  nixpkgs.config.allowUnfree = true;
  home.packages = [
    pkgs.gcc
    pkgs.go
    pkgs.lua
    pkgs.slack
    pkgs.todoist
    pkgs.discord
    pkgs.obsidian
    pkgs.lazygit
  ];

  programs.home-manager.enable = true;
}
