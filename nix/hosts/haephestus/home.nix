{ pkgs, inputs, ... }:
{
  imports = [
    ../../modules/home
  ];
  home = {
    username = "nixos";
    homeDirectory = "/home/nixos";

    stateVersion = "24.11";
  };

  git = {
    enable = true;
    userEmail = "emilio.palmerini@condiceplastico.com";
    userName = "emiliopalmerini";
  };

  kitty.enable = true;
  ghostty.enable = true;
  gcc.enable = true;
  go.enable = true;
  lazygit.enable = true;
  shell.enable = true;
  tmux.enable = true;
  make.enable = true;
  neovim.enable = true;

  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;
}
