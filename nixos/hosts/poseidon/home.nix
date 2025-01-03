{ config, pkgs, inputs, ... }:

{
  imports = [
  	./../../modules/homeManagerModules
  ];
  home.username = "prometeo";
  home.homeDirectory = "/home/prometeo";

  home.stateVersion = "24.11"; # Please read the comment before changing.

  neovim.enable = true;

  git.enable = true;
  git.userName = "emiliopalmerini";
  git.userEmail = "emiliopalmerini@proton.me";

  tmux.enable = true;
  customShell.enable = true;

  nixpkgs.config.allowUnfree = true;
  home.packages = [
    pkgs.gcc
    pkgs.go
    pkgs.lua
    pkgs.lazygit
  ];

  programs.home-manager.enable = true;
}
