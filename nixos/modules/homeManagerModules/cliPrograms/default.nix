{ config, pkgs, inputs, ... }:
{
  imports = [
    ./git
    ./neovim
    ./tmux.nix
  ];
}

