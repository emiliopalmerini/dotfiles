{ config, pkgs, inputs, ... }:
{
  imports = [
    ./firefox.nix
    ./kitty.nix
    ./slack.nix
    ./discord.nix
  ];
}

