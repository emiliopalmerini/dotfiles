{ config, pkgs, inputs, ... }:

{
  imports = [
  	./../../modules/home
  ];

  home.username = "emil_io";
  home.homeDirectory = "/home/emil_io";

  home.stateVersion = "24.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
  ];

  firefox.enable = true;

  git.enable = true;
  git.userEmail = "emiliopalmerini@codiceplastico.com";
  git.userName = "emiliopalmerini";

  kitty.enable = true;

  go.enable = true;
  gcc.enable = true;

  lazygit.enable = true;
  neovim.enable = true;
  obs.enable = true;
  obsidian.enable = true;
  shell.enable = true;
  slack.enable = true;
  tmux.enable = true;
  todoist.enable = true;
  make.enable = true;
  mongodb.enable = true;

  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;
}
