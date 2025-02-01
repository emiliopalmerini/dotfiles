{ config, pkgs, inputs, ... }:
{
  imports = [
    ./bruno
    ./discord
    ./dotnet
    ./firefox
    ./gcc
    ./gimp
    ./git
    ./go
    ./gui
    ./hyprland
    ./kitty
    ./lazygit
    ./lua
    ./mongodb
    ./neovim
    ./obsidian
    ./rectangle
    ./shell
    ./slack
    ./tmux
    ./todoist
  ];
}

