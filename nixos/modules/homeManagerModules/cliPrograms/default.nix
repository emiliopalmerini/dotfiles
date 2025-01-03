{ config, pkgs, inputs, ... }:
{
  imports = [
    ./git
    ./neovim.nix
    ./tmux.nix
  ];
}

