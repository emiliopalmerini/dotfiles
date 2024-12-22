{ config, pkgs, inputs, ... }:
{
  imports = [
    ./firefox.nix
    ./kitty.nix
  ];
}

