{ config, pkgs, inputs, ... }:
{
  imports = [
    ./terminals
    ./discord.nix
    ./firefox.nix
    ./gimp.nix
    ./lazygit.nix
    ./mongodbClients.nix
    ./obsidian.nix
    ./rectangle.nix
    ./todoist.nix
  ];
}

