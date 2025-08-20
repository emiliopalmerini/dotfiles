{ config
, pkgs
, inputs
, ...
}: {
  imports = [
    ./../../modules/home
  ];

  home.username = "prometeo";
  home.homeDirectory = "/home/prometeo";

  home.stateVersion = "24.11"; # Please read the comment before changing.

  firefox.enable = true;

  git.enable = true;
  git.userEmail = "emilio.palmerini@gmail";
  git.userName = "emiliopalmerini";

  lazygit.enable = true;
  neovim.enable = true;
  shell.enable = true;
  tmux.enable = true;

  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;
}
