{ config, pkgs, inputs, ... }:
{
  imports = [
    ./antivirus
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
    ./make
    ./mongodb
    ./neovim
    ./obs
    ./obsidian
    ./postman
    ./rectangle
    ./shell
    ./slack
    ./telegram
    ./tmux
    ./todoist
    ./unity
    ./vscode
  ];
}

