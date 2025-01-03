{ config, pkgs, inputs, ... }:
{
  imports = [
    ./hyprland
    ./customShell
    ./dotnet.nix
  ];
}

