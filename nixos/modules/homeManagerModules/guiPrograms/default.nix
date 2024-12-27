{ config, pkgs, inputs, ... }:
{
  imports = [
    ./terminals
    ./firefox.nix
    ./obsidian.nix
  ];
}

