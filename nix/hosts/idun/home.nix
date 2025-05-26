{ pkgs, inputs, ... }:
{
  imports = [
    ./../../modules/home
  ];
  home.stateVersion = "24.11"; # Please read the comment before changing.
  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    mongosh
    raycast
  ];

  bruno.enable = true;
  discord.enable = false;
  gcc.enable = true;
  gimp.enable = true;
  git.enable = true;
  git.userEmail = "emiliopalmerini@proton.me";
  git.userName = "emiliopalmerini";
  go.enable = true;
  httpie.enable = true;
  hugo.enable = false;
  lazygit.enable = true;
  lua.enable = true;
  neovim.enable = true;
  postgres.enable = true;
  shell.enable = true;
  sqlite.enable = true;
  telegram.enable = true;
  tmux.enable = true;
  todoist.enable = true;
  tailscale.enable = true;
}

