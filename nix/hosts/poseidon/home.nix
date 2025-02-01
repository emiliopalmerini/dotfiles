{ config, pkgs, inputs, ... }:

{
  imports = [
  	./../../modules/homeManagerModules
  ];
  home.username = "prometeo";
  home.homeDirectory = "/home/prometeo";

  home.stateVersion = "24.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
  ];

  firefox.enable = true;

  git.enable = true;
  git.userName = "emiliopalmerini";
  git.userEmail = "emiliopalmerini@proton.me";

  go.enable = true;
  gcc.enable = true;

  lazygit.enable = true;
  neovim.enable = true;
  shell.enable = true;
  tmux.enable = true;

  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;
}
