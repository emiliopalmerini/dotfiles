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
    ./hyprland
    ./kitty
    ./lazygit
    ./lua
    ./mongodb
    ./neovim
    ./obsidian
    ./postman
    ./rectangle
    ./shell
    ./slack
    ./tmux
    ./todoist
  ];
}

