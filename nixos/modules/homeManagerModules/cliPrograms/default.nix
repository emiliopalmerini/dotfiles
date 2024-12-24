{ config, pkgs, inputs, ... }:
{
  imports = [
    ./neovim.nix
    ./git.nix
    ./tmux.nix
    ./zsh.nix
  ];
}

