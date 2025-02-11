{ config, pkgs, inputs, ... }:

{
  imports = [
  	./../../modules/home
  ];

  home.stateVersion = "24.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    raycast
  ];

  neovim.enable = true;

  git.enable = true;
  git.userName = "emiliopalmerini";
  git.userEmail = "emiliopalmerini@proton.me";

  tmux.enable = true;
  telegram.enable = true;
  shell.enable = true;
  todoist.enable = true;
  gcc.enable = true;
  go.enable = true;
  lua.enable = true;
  kitty.enable = true;

  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;
}
