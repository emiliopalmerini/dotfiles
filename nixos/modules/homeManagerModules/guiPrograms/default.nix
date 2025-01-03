{ config, pkgs, inputs, ... }:
{
  imports = [
    ./terminals
    ./firefox.nix
    ./mongodbClients.nix
  ];
}

