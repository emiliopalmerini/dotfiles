{ config, pkgs, inputs, ... }:
{
  imports = [
    ./neovim.nix
    ./git.nix
  ];
}

