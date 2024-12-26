{ config, pkgs, inputs, ... }:
{
  imports = [
    ./git
    ./neovim.nix
    ./shell
    ./tmux.nix
  ];
}

