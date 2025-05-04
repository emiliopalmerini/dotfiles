{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.nvf.homeManagerModules.default
    ./../../modules/home
  ];

  home.username = "emilio";
  home.homeDirectory = "/home/emilio";

  home.stateVersion = "24.11"; # Please read the comment before changing.

  firefox.enable = false;
  chrome.enable = true;

  dbeaver.enable = true;
  git = {
    enable = true;
    userEmail = "emilio.palmerini@codiceplastico.com";
    userName = "emiliopalmerini";
  };

  kitty.enable = true;
  ghostty.enable = true;

  go.enable = true;
  gcc.enable = false;
  dotnet.enable = true;

  lazygit.enable = true;
  neovim.enable = false;
  nvf.enable = true;
  obsidian.enable = true;
  shell.enable = true;
  tmux.enable = true;
  make.enable = true;

  mongodb.enable = true;
  slack.enable = true;
  bruno.enable = true;

  vm.enable = true;

  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;
}
